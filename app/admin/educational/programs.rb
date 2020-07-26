ActiveAdmin.register Educational::Program do
  menu false


  index do
    selectable_column
    id_column
    column :program_type
    column :level
    column :name
    column :code
    column :okso_code
    column :ugs_code
    column :qualification
    column :accredited
    column :canceled
    column :suspended

    actions
  end

end
