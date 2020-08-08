class City < ApplicationRecord
  belongs_to :region, optional: true
  has_one :district, through: :region
  has_many :schools

  class << self
    def ransackable_scopes(auth_object = nil)
      %i( name_select_in )
    end

    def ransackable_scopes_skip_sanitize_args
      %i( name_select_in )
    end

    def name_select_in(*params)
      where(id: params)
    end
  end

  def delete_schools
    schools.delete_all
  end
end
