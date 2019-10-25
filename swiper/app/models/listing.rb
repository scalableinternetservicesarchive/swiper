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
end
  