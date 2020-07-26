ActiveAdmin.register Educational::ProgramType do
  menu false

  index do
    selectable_column
    id_column
    column :name

    actions
  end

end
