module ApplicationHelper
    def flash_class(level)
        case level
            when 'notice' then "notification is-link"
            when 'success' then "notification is-success"
            when 'error' then "notification is-danger"
            when 'alert' then "notification is-warning"
        end
    end
    
    def lowest_price(location)
        listing = Listing.where(location: location, buyer: nil).order(:price).first
        return number_with_precision(listing.price, precision: 2) if listing
        0
    end

    def filter_checked(location)
        return 1 if :filter && :filter[location] && :filter[location] == '1'
        0
    end

    def location_to_string(location)
        case location
        when 'BPlate'
            "Bruin Plate"
        when 'Covel'
            "Covel"
        when 'DeNeve'
            "De Neve"
        when 'Feast'
            "Feast"
        when 'BCafe'
            "Bruin Cafe"
        when 'Cafe1919'
            "Cafe 1919"
        when 'Rende'
            "Rendezvous"
        when 'Study'
            "The Study"
        else
            ""
        end
    end
end
