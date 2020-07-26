class CreateEducationalUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_units do |t|
      t.string :uuid
      t.string :name
      t.string :short_name
      t.string :head_uuid
      t.boolean :branch
      t.string :address
      t.string :phone
      t.string :email
      t.string :site
      t.string :ogrn
      t.string :inn
      t.string :head_post
      t.string :head_name

      t.references :region

      t.timestamps
    end
  end
end
