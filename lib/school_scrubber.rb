class SchoolScrubber
  def initialize(row)
    @row = row
  end

  def clean_name
    @row['name'].gsub(/[[:space:]]/, " ").gsub(/ +/, " ").strip
  end

  def clean_address
    @row['address'].gsub!(/[^0-9А-Яа-я\.,]/, '')
  end

  def clean_director
    @row['director'].strip
  end

  def parse_phones
    @row['phone'].split(/([\d\+\-\(\)]+)+/).select{|x| x.present?}
  end

  def parse_email
    Array.wrap(@row['email'].gsub(/[[:space:]]/, ''))
  end

  def clean_site
    @row['site'].gsub(/[[:space:]]/, '')
  end
end
