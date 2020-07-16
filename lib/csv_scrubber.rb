class CsvScrubber < SchoolScrubber
  def initialize(importer)
    @importer = importer
  end

  def scrub
    headers = @importer.headers

    headers.each do |header|
      next if header[1] == :city_id
      values = @importer.values_at(header[1])
      scrub_value = values.reduce({}) do |memo, value|
        memo.merge(value => send("scrub_#{header[1]}", value))
      end
      @importer.batch_replace(header[1], scrub_value)
    end

    values = @importer.values_at(:city_id)
    cities = City.where(name: values).pluck(:name, :id).to_h
    @importer.batch_replace(:city_id, cities)
  end

  def scrub_site(text)
    super.join(',')
  end

  def scrub_phone(text)
    "{#{super&.join(',')}}"
  end

  def scrub_email(text)
    "{#{super&.join(',')}}"
  end
end
