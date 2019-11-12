module ApplicationHelper
    def lowest_price(location)
        listings = Listing.where(location: location, buyer: nil).order(:price).first
        return number_with_precision(listings, precision: 2) if listings 
        0
    end

    def filter_checked(location)
        return 1 if :filter && :filter[location] && :filter[location] == '1'
        0
    end
end
