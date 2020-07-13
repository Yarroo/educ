class SchoolScrubber
  def initialize(row)
    @row = row
  end

  def result
    {
        name: scrub_name(@row['name']),
        address: scrub_address(@row['address']),
        director: scrub_director(@row['director']),
        phone: scrub_phone(@row['phone']),
        email: scrub_email(@row['email']),
        site: scrub_site(@row['site']),
        short_name: scrub_short_name(@row['short_name'])
    }
  end

  def scrub_short_name(text)
    text&.gsub(/[[:space:]]/, " ")&.gsub(/ +/, " ")&.strip
  end

  def scrub_name(text)
    text&.gsub(/[[:space:]]/, " ")&.gsub(/ +/, " ")&.strip
  end

  def scrub_address(text)
    text&.gsub!(/[^0-9А-Яа-я\.,]/, '')
  end

  def scrub_director(text)
    text&.strip
  end

  def scrub_phone(text)
    text&.scan(School::FIND_PATTERN[:phone]).flatten.select{|x| x.length > 5}
  end

  def scrub_email(text)
    text&.gsub('@ ', '@')&.scan(School::FIND_PATTERN[:email]).flatten
  end

  def scrub_site(text)
    URI.extract(text)
  end
end
