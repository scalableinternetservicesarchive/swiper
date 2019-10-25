class ListingsController < ApplicationController
    def index
        @listings = Listing.paginate(page: params[:page])
    end

    def show
        @listing = Listing.find(params[:id])
    end

    def new
        @listing = Listing.new
    end

    def create
        @listing = current_user.listings.new(listing_params)

        if @listing.save
            redirect_to listing_path(@listing), notice: "Listing Created!"
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
            redirect_to listing_path(@listing), notice: "Listing Updated!"
        else
            @errors = @listing.errors.full_messages
            render :edit
        end
    end

    def destroy
        listing = Listing.find(params[:id])
        listing.destroy
        redirect_to listings_path, notice: "Deleted Listing for  #{listing.pretty_location()}"
    end

    private

    def listing_params
        params.require(:listing).permit(:location, :description, :start_time, :end_time, :price)
    end
end