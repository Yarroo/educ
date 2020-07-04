class CreateRegions < ActiveRecord::Migration[6.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.integer :code
      t.references :district

      t.timestamps
    end
  end
end
