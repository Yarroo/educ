class CsvScrubber < SchoolScrubber
  def initialize(importer)
    @importer = importer
  end

  def scrub
    @importer.csv_lines = @importer.csv_lines.select { |line| line.compact.present?}

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
    cities = values.reduce({}) do |memo, value|
      unless memo[value].present?
        id = City.where("name ILIKE ?", value.strip).pluck(:id).first
        memo.merge!(value => id)
      end
    end
    @importer.batch_replace(:city_id, cities)
  end

  def scrub_email(text)
    "{#{super&.join(',')}}"
  end
end
