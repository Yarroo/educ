class Region < ApplicationRecord
  belongs_to :district
  has_many :cities
end
