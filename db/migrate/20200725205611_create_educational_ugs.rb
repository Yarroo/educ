class CreateEducationalUgs < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_ugs_codes do |t|
      t.string :name
      t.string :code

      t.index :code

      t.timestamps
    end
  end
end
