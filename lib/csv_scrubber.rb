class CsvScrubber < SchoolScrubber
  def initialize(importer)
    @importer = importer
  end

  def scrub
    delete_empty_row
    scrub_rows
    set_city_and_region
    @importer.batch_slice_columns(['name', 'short_name', 'address', 'director', 'phone', 'email', 'site', :city_id ])
  end

  def delete_empty_row
    @importer.csv_lines = @importer.csv_lines.select { |line| line.compact.present?}
  end

  def scrub_rows
    @importer.headers.each do |header|
      next if header[1] == :city_id || header[1] == "region"

      values = @importer.values_at(header[1])
      scrub_value = values.reduce({}) do |memo, value|
        memo.merge(value => send("scrub_#{header[1]}", value))
      end

      @importer.batch_replace(header[1], scrub_value)
    end
  end

  def set_city_and_region
    cities_values = @importer.values_at(:city_id)
    region_values = @importer.headers.map(&:last).include?("region") ? @importer.values_at("region") : []

    values = cities_values.map.with_index { |city, index| [city, region_values[index]]}

    cities = values.reduce({}) do |memo, value|
      region_name = value[1]
      city_name = value[0]
      region_id = Region.where("name ILIKE ?", region_name.strip).pluck(:id).first if region_name.present?

      query = City.where("name ILIKE ?", city_name.strip)
      query = query.where(region_id: region_id) if region_id.present?
      city_id = query.pluck(:id).first

      memo.merge!(city_name => city_id)
    end

    @importer.batch_replace(:city_id, cities)
  end

  def scrub_email(text)
    "{#{super&.join(',')}}"
  end
end
