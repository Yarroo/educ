class CreateEducationPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_programs do |t|
      t.string :name
      t.string :code
      t.string :okso_code
      t.string :qualification
      t.boolean :accredited
      t.boolean :canceled
      t.boolean :suspended

      t.references :program_type, foreign_key: { to_table: 'educational_program_types' }
      t.references :ugs_code, foreign_key: { to_table: 'educational_ugs_codes' }
      t.references :level, foreign_key: { to_table: 'educational_levels' }

      t.timestamps
    end
  end
end
