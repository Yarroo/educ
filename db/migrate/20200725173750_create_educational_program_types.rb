class CreateEducationalProgramTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :educational_program_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
