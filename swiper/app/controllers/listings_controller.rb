class ListingsController < ApplicationController

    private
    def listing_params
        params.require(:listing).permit(:location, :description, :start_time, :end_time, :price, :reserved_amount, :reserved_time)
    end

    def filter_listings(filter_params)
        selected_locations = []
        Listing.locations.keys.each do |loc|
            if filter_params[loc] == '1'
                selected_locations << loc
            end
        end
        
        filtered = Listing.where(location: selected_locations, buyer: nil, completed: false)
        if(current_user)
            filtered = filtered.where.not(user_id: current_user.id)
        end
        filtered = filtered.where("price <= ?", filter_params[:price]) unless !filter_params[:price] || filter_params[:price].empty?
        filtered = filtered.where("? <= amount", filter_params[:amount]) unless !filter_params[:amount] || filter_params[:amount].empty?
        return filtered
    end

    public
    def index
        if params[:filter]
            @listings = filter_listings(params[:filter]).paginate(page: params[:page]).order(:price)
        else
            if(current_user)
                @listings = Listing.where(buyer: nil, completed: false).where.not(user_id: current_user.id).paginate(page: params[:page]).order(:price)
            else
                @listings = Listing.where(buyer: nil, completed: false).paginate(page: params[:page]).order(:price)
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
            redirect_to listing_path(@listing, :id => params[:id]), :flash => { :error => "This listing cannot currently be reserved" }
        end

        if @listing.update({:buyer => current_user.id, :reserved_amount => params[:listing][:reserved_amount], :reserved_time => params[:listing][:reserved_time]})
            redirect_to listing_path(@listing), :flash => { :success => "Listing reserved!" }
        else
            @errors = @listing.errors.full_messages
            render :show
        end
    end

    def complete
        @listing = Listing.find(params[:id])
        if @listing.buyer != current_user.id
            redirect_to listing_path(@listing, :id => params[:id]), :flash => { :error => "You cannot currently complete this listing!" }
        end

        if @listing.update({:completed => true})
            redirect_to listing_path(@listing), :flash => { :success => "Transaction completed!" }
        else
            @errors = @listing.errors.full_messages
            render :show
        end
    end

end
