class AddPhoneStringToSchool < ActiveRecord::Migration[6.0]
  def change
    rename_column :schools, :phone, :phone_array
    add_column :schools, :phone, :text
  end
end
