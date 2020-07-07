class CreateSchools < ActiveRecord::Migration[6.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :short_name
      t.string :director
      t.string :email, array: true, default: []
      t.string :address
      t.string :phone
      t.string :site

      t.references :city

      t.timestamps
    end
  end
end
