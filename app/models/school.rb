class School < ApplicationRecord
  belongs_to :city
  has_one :region, through: :city
  has_one :distinct, through: :city

end
