# coding: utf-8
class Import < Thor
  include Thor::Actions

  no_commands do
    def load_env
      return if defined?(Rails)
      require File.expand_path("../../../config/environment", __FILE__)
    end
  end

  desc 'cities', 'cities'
  option :file_path
  def cities
    load_env

    file_path = options[:file_path] ||  Rails.root.join('tmp', 'persisted', 'cities.csv')

    unless File.file?(file_path)
      pp "Script stop. File not found"
      return
    end

    total = `wc -l '#{file_path}'`.to_i - 1
    count = 0

    CSV.foreach(file_path, :headers => true) do |row|
      district = District.find_or_initialize_by(name: row['district'])
      district.save if district.changed?


      region = Region.find_or_initialize_by(name: row['region'], district_id: district.id)
      region.save if region.changed?

      city = City.find_or_initialize_by(name: row['city'], region_id: region.id)
      city.population = row['population'].to_i
      city.save if city.changed?

      count += 1
      printf("\r%d/%d", count, total) if STDOUT.tty?
    end

    puts if STDOUT.tty?
  end

end
