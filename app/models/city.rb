class City < ApplicationRecord
  belongs_to :region
  has_one :district, through: :region
  has_many :schools

end
