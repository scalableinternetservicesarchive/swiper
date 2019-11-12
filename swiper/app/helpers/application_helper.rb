module ApplicationHelper
    def lowest_price(location)
        listing = Listing.where(location: location, buyer: nil).order(:price).first
        return number_with_precision(listing.price, precision: 2) if listing
        0
    end

    def filter_checked(location)
        return 1 if :filter && :filter[location] && :filter[location] == '1'
        0
    end
end
