class CreateJoinTableEducationalUnitsPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_programs_units do |t|
      t.references :unit, foreign_key: { to_table: 'educational_units' }
      t.references :program, foreign_key: { to_table: 'educational_programs' }
    end
  end
end
