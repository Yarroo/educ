class District < ApplicationRecord
  has_many :regions
  has_many :cities, through: :regions
  has_many :schools, through: :cities

end
