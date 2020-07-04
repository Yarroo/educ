class Region < ApplicationRecord
  has_one :district
  has_many :cities
end
