class ListingsController < ApplicationController
    def index
        @listings = Listing.all
    end

    def show
        @listing = Listing.find(params[:id])
    end

    def new
        @listing = Listing.new
    end

    def create
        @listing = Listing.new(listing_params)

        if @listing.save
            redirect_to listing_path(@listing), notice: "Listing Created!"
        else
            @errors = @listing.errors.full_messages
            render :new
        end
    end

    def destroy
        listing = Listing.find(params[:id])
        listing.destroy
        redirect_to listings_path, notice: "Deleted Listing: #{listing.name}"
    end

    private

    def listing_params
        params.require(:listing).permit(:name, :description)
    end
end