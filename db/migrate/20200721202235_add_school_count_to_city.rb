class AddSchoolCountToCity < ActiveRecord::Migration[6.0]
  def change
    add_column :cities, :schools_count, :integer

    City.find_each { |city| City.reset_counters(city.id, :schools) }
  end
end
