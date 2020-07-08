class ChangePhoneToArray < ActiveRecord::Migration[6.0]
  def change
    remove_column :schools, :phone
    add_column :schools, :phone, :string, array: true, default: []
  end
end
