class ListingsController < ApplicationController

    private
    def listing_params
        params.require(:listing).permit(:location, :description, :start_time, :end_time, :price, :reserved_amount, :reserved_time, :amount, :rating)
    end

    def filter_listings(filter_params)
        selected_locations = []
        Listing.locations.keys.each do |loc|
            if filter_params[loc] == '1'
                selected_locations << loc
            end
        end
        
        filtered = Listing.where(location: selected_locations, buyer: nil, completed: false)
        if current_user
            filtered = filtered.where.not(user_id: current_user.id)
        end
        filtered = filtered.where("price <= ?", filter_params[:price]) unless !filter_params[:price] || filter_params[:price].empty?
        filtered = filtered.where("? <= amount", filter_params[:amount]) unless !filter_params[:amount] || filter_params[:amount].empty?
        
        if filter_params[:cash] == "1" || filter_params[:venmo] == "1" || filter_params[:paypal] == "1" || filter_params[:cashapp] == "1"
            filtered_dup = filtered
            filtered = Listing.none
            if filter_params[:cash] == "1"
                filtered = filtered.or(filtered_dup.joins(:user).where(users: {cash: 1}))
            end
            
            if filter_params[:venmo] == "1"
                filtered =filtered.or(filtered_dup.joins(:user).where(users: {venmo: 1}))
            end

            if filter_params[:paypal] == "1"
                filtered = filtered.or(filtered_dup.joins(:user).where(users: {paypal: 1}))
            end

            if filter_params[:cashapp] == "1"
                filtered = filtered.or(filtered_dup.joins(:user).where(users: {cashapp: 1}))
            end
        end

        if !(!params[:filter]["earliest(4i)"] ||
            !params[:filter]["earliest(5i)"] ||
            !params[:filter]["latest(4i)"] ||
            !params[:filter]["latest(5i)"] ||
            params[:filter]["earliest(4i)"].empty? ||
            params[:filter]["earliest(5i)"].empty? ||
            params[:filter]["latest(4i)"].empty? ||
            params[:filter]["latest(5i)"].empty?
        )
            earliest = DateTime.new(
                Time.current.strftime("%Y").to_i,
                Time.current.strftime("%m").to_i,
                Time.current.strftime("%e").to_i,     
                params[:filter]["earliest(4i)"].to_i,
                params[:filter]["earliest(5i)"].to_i
            )

            latest = DateTime.new(
                Time.current.strftime("%Y").to_i,
                Time.current.strftime("%m").to_i,
                Time.current.strftime("%e").to_i,     
                params[:filter]["latest(4i)"].to_i,
                params[:filter]["latest(5i)"].to_i
            )

            earliest += 1.day if earliest <= Time.current and latest <= Time.current and earliest <= latest
            latest += 1.day if latest <= Time.current or latest <= earliest

            filtered = filtered.where(
                "(start_time between ? and ? or end_time between ? and ?) or (start_time <= ? and ? <= end_time)",
                earliest, latest, earliest, latest, earliest, latest)
        end

        return filtered
    end

    public
    def index
        sort = "price ASC"
        if params[:sort]
            sort = params[:sort]
        end
        if params[:filter]
            @listings = filter_listings(params[:filter]).paginate(page: params[:page]).order(sort)
        else
          if(current_user)
                @listings = Listing.where(buyer: nil, completed: false).where.not(user_id: current_user.id).paginate(page: params[:page]).order(sort)
            else
                @listings = Listing.where(buyer: nil, completed: false).paginate(page: params[:page]).order(sort)
          end
        end
    end

    def show
        if current_user.nil?
            redirect_to sign_up_path, :flash => { :alert => "Please log in or sign up to reserve swipes!" }
        else
            @listing = Listing.find(params[:id])
        end
    end

    def new
        @listing = Listing.new
    end

    def create
        @listing = current_user.listings.new(listing_params)

        if @listing.save
            redirect_to listing_path(@listing), :flash => { :success => "Listing created!" } 
        else
            @errors = @listing.errors.full_messages
            render :new
        end
    end

    def edit
        @listing = current_user.listings.find(params[:id])
    end

    def update
        @listing = current_user.listings.find(params[:id])

        if @listing.update_attributes(listing_params)
            redirect_to listing_path(@listing), :flash => { :success => "Listing updated!" }
        else
            @errors = @listing.errors.full_messages
            render :edit
        end
    end

    def destroy
        listing = Listing.find(params[:id])
        listing.destroy
        redirect_to listings_path, :flash => { :success => "Listing deleted!" }
    end

    def reserve
        @listing = Listing.find(params[:id])
        
        if @listing.buyer != nil
            redirect_to listing_path(@listing, :id => params[:id]), :flash => { :error => "This listing cannot currently be reserved" } and return
        end

        if params[:listing]["reserved_time(4i)"].empty?|| params[:listing]["reserved_time(5i)"].empty?
            redirect_to listing_path(@listing, :id => params[:id]), :flash => { :error => "Please select a valid time" } and return
        end
        
        # If the reservation time is before the current time (without date), it must be for the next day
        if Time.current.change(hour: params[:listing]["reserved_time(4i)"].to_i, minute: params[:listing]["reserved_time(5i)"].to_i).strftime("%H%M%S%N") <= Time.current.strftime("%H%M%S%N")
            date = Time.current + 1.day
        else
            date = Time.current
        end

        if @listing.update({:buyer => current_user.id, :reserved_amount => params[:listing][:reserved_amount], :reserved_time => 
            DateTime.new(
                        date.strftime("%Y").to_i,
                        date.strftime("%m").to_i,
                        date.strftime("%e").to_i,     
                        params[:listing]["reserved_time(4i)"].to_i,
                        params[:listing]["reserved_time(5i)"].to_i
                    )})
            redirect_to listing_path(@listing), :flash => { :success => "Listing reserved!" }
        else
            @errors = @listing.errors.full_messages
            render :show
        end
    end

    def complete
        @listing = Listing.find(params[:id])
        @seller = User.find(@listing.user_id)

        params[:rating] = params[:rating].to_i
        if params[:rating] > 5 || params[:rating] < 0
            redirect_to listing_path(@listing, :id => params[:id]), :flash => { :error => "You submitted an invalid rating value!" } and return
        else
            puts @seller.rating
            if @seller.rating == nil
                @seller.rating = 0
            end
                
            new_rating = @seller.rating + ((params[:rating] - @seller.rating) / (@seller.rating_count + 1))
            
            @seller.update({:rating => new_rating})
            @seller.update({:rating_count => @seller.rating_count + 1})
        end

        if @listing.buyer != current_user.id
            redirect_to listing_path(@listing, :id => params[:id]), :flash => { :error => "You cannot currently complete this listing!" } and return
        end

        if @listing.update({:completed => true})
            redirect_to listing_path(@listing), :flash => { :success => "Transaction completed!" }
        else
            @errors = @listing.errors.full_messages
            render :show
        end
    end

end
