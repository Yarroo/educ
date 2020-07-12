ActiveAdmin.register UserRole do
  permit_params :name, :role

  index do
    selectable_column
    id_column
    column :name
    column :role
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :role
    end
    f.actions
  end

end
