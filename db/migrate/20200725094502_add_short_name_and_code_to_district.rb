class AddShortNameAndCodeToDistrict < ActiveRecord::Migration[6.0]
  def change
    change_table :districts do |t|
      t.string :short_name
      t.string :code

      t.index :short_name
    end
  end
end
