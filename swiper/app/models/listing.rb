class Listing < ApplicationRecord
    belongs_to :user
    enum location: %i[
                    BPlate
                    Covel 
                    DeNeve 
                    Feast 

                    BCafe 
                    Cafe1919 
                    Rende  
                    Study 
    ]
    enum status: %i[
        posted  
        matched  
        completed 
    ]
end
  