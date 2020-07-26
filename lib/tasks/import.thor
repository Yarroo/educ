# coding: utf-8
class Import < Thor
  include Thor::Actions

  no_commands do
    def load_env
      return if defined?(Rails)
      require File.expand_path("../../../config/environment", __FILE__)
    end

    def save_log(rows)
      CSV.open("#{Rails.root}/tmp/persisted/error_log.csv", "wb") do |csv|
        csv << ['row', 'status' ]
        rows.each do |hotel|
          csv << [
              rows[0],
              rows[1],
          ]
        end
      end
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

  desc 'school', 'school'
  option :file_path
  def school
    load_env

    file_path = options[:file_path] ||  Rails.root.join('tmp', 'persisted', 'school.csv')

    unless File.file?(file_path)
      pp "Script stop. File not found"
      return
    end

    total = `wc -l '#{file_path}'`.to_i - 1
    count = 0
    log = []

    CSV.foreach(file_path, :headers => true) do |row|
      count += 1
      printf("\r%d/%d", count, total) if STDOUT.tty?

      region = Region.where("name ilike ?", "%#{row['region']}%")

      if region.count > 1 &&  region.count == 0
        status = region.count == 0 ? "no region" : "several regions"
        log << [row, status]
        next
      end

      city_rel = City.where("name ilike ?", "%#{row['city']}%")
      if city_rel.count > 1
        log << [row, "several cities"]
        next
      elsif city_rel.count == 0
        city = City.create(name: row['city'], region: region.first)
      else
        city = city_rel.first
      end

      school_scrubber = SchoolScrubber.new(row)

      school = School.find_or_initialize_by(name: school_scrubber.clean_name, city: city)
      school.address = school_scrubber.clean_address
      school.director = school_scrubber.clean_director
      school.phone = school_scrubber.parse_phones
      school.email = school_scrubber.parse_email
      school.site = school_scrubber.clean_site

      school.save if school.changed?
    end

    puts if STDOUT.tty?

    if log.present?
      save_log(log)
      puts "Errors. Log save"
    end
  end

  desc 'from_xml', ''
  option :file_path
  def xml_region_and_district
    load_env

    file_path = options[:file_path] ||  Rails.root.join('tmp', 'persisted', 'data.xml')

    unless File.file?(file_path)
      pp "Script stop. File not found"
      return
    end

    count = 0

    Nokogiri::XML::Reader(File.open(file_path)).each do |node|
      if node.name == 'Certificate' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        hash = Hash.from_xml(Nokogiri::XML(node.outer_xml).at('./Certificate').to_s)

        certificate = hash["Certificate"]

        district = District.find_or_initialize_by(name: certificate["FederalDistrictName"])
        district.short_name = certificate["FederalDistrictShortName"]
        district.code = certificate["FederalDistrictCode"]
        district.save if district.changed?

        region = Region.find_or_initialize_by(name: certificate["RegionName"])
        region.code = certificate["RegionCode"]
        region.district = district
        region.save if region.changed?

        count += 1
        printf("\r%d", count, ) if STDOUT.tty?
      end
    end
  end

  desc 'from_xml', ''
  option :file_path
  def xml_educational_program
    load_env

    file_path = options[:file_path] ||  Rails.root.join('tmp', 'persisted', 'data.xml')

    unless File.file?(file_path)
      pp "Script stop. File not found"
      return
    end

    count = 0

    Nokogiri::XML::Reader(File.open(file_path)).each do |node|
      if node.name == 'EducationalProgram' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        hash = Hash.from_xml(Nokogiri::XML(node.outer_xml).at('./EducationalProgram').to_s)

        program = hash["EducationalProgram"]

        if program["TypeName"].present?
          program_type = Educational::ProgramType.find_or_initialize_by(name:  program["TypeName"])
          program_type.save if program_type.changed?
        end

        if program["EduLevelName"].present?
          level = Educational::Level.find_or_initialize_by(name: program["EduLevelName"])
          level.save if level.changed?
        end

        if program['UGSCode'].present?
          ugs_code = Educational::UgsCode.find_or_initialize_by(code: program['UGSCode'])
          ugs_code.name = program["UGSName"]
          ugs_code.save if ugs_code.changed?
        end

        edu_program = Educational::Program.find_or_initialize_by(
            name:  program["ProgrammName"],
            code:   program["ProgrammCode"],
            okso_code: program["OKSOCode"],
            level: level,
        )

        edu_program.program_type = program_type if program_type.present?
        edu_program.ugs_code = ugs_code if ugs_code.present?
        edu_program.qualification = program["Qualification"] if program["Qualification"].present?
        edu_program.accredited = program["IsAccredited"].present?
        edu_program.canceled = ActiveModel::Type::Boolean.new.cast(program["IsCanceled"])
        edu_program.suspended = ActiveModel::Type::Boolean.new.cast(program["IsSuspended"])
        edu_program.save if edu_program.changed?

        count += 1
        printf("\r%d", count, ) if STDOUT.tty?
      end
    end

    puts if STDOUT.tty?
  end
end
