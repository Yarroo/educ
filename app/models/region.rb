class Region < ApplicationRecord
  belongs_to :district, optional: true
  has_many :cities
  has_many :schools, through: :cities

end
