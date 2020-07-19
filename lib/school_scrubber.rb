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
    text&.strip
  end

  def scrub_email(text)
    text&.gsub('@ ', '@')&.scan(School::FIND_PATTERN[:email])&.flatten
  end

  def scrub_site(text)
    uri_array = text&.scan(School::FIND_PATTERN[:site])
    uri_array&.map do |uri|
      uri = "http://#{uri}" unless uri.start_with?("http://") || uri.start_with?("https://")
      URI.extract(URI.encode(uri))
    end&.flatten&.join(",")
  end
end
