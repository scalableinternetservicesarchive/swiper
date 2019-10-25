class Listing < ApplicationRecord
    belongs_to :user
    enum location: %i[
                    b_plate 
                    covel 
                    de_neve 
                    feast 

                    b_cafe 
                    nineteen_nineteen 
                    rende  
                    study 
    ]
    enum status: %i[
        posted  
        matched  
        completed 
    ]

    @@names =  {
        b_plate: "BPlate", 
        covel: "Covel", 
        de_neve: "DeNeve", 
        feast: "Feast", 

        b_cafe: "BCafe", 
        nineteen_nineteen: "1919", 
        rende: "Rende",  
        study: "Study"
    }

    def pretty_location
        @@names[location.to_sym]
    end

    def self.pretty_location(location)
        @@names[location.to_sym]
    end
end
  