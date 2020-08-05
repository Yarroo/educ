namespace :counter do
  desc 'Add parser ratings'
  task cities: :environment do
    City.find_each do |city|
      City.reset_counters(city.id, :schools)
    end
  end
end