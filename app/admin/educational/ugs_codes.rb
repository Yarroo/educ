ActiveAdmin.register Educational::UgsCode do
  menu false

  index do
    selectable_column
    id_column
    column :name
    column :code

    actions
  end

end
