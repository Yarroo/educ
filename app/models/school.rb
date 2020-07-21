class School < ApplicationRecord
  belongs_to :city, counter_cache: true
  has_one :region, through: :city, source: :region
  has_one :district, through: :region, source: :district

  FIND_PATTERN = {
      email: /([a-z\-\–_\d\.]*@[a-z\d]*\.[a-z]*)+/i,
      phone: /([\d\+\-\(\)]+)+/,
      site: /[[:word:]*:\/\/]*[[:word:]-]*\.[[:word:]-]*[\.[:word:]-]*/i,
  }

end
