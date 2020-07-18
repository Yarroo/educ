class UpdatePhonestingInSchool < ActiveRecord::Migration[6.0]
  def change
    School.all.find_each { |school| school.update_attributes(phone: school.phone_array.join(", ")) }
  end
end
