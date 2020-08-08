class City < ApplicationRecord
  belongs_to :region, optional: true
  has_one :district, through: :region
  has_many :schools

  def delete_schools
    schools.delete_all
  end
end
