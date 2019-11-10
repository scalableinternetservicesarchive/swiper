module ApplicationHelper
    def lowest_price(location)
        number_with_precision(Listing.where(location: location, buyer: nil).order(:price).first.price, precision: 2)
    end

    def filter_checked(location)
        return 1 if :filter && :filter[location] && :filter[location] == '1'
        0
    end
end
