class City < ApplicationRecord
  belongs_to :region, optional: true
  has_one :district, through: :region
  has_many :schools

end
