class Region < ApplicationRecord
  belongs_to :district
  has_many :cities
  has_many :schools, through: :cities

end
