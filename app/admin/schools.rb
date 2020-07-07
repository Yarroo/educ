ActiveAdmin.register City do
  actions :index, :show

  index do
    selectable_column
    id_column

    column :name
    column :short_name
    column :director
    column :email
    column :address
    column :phone
    column :site
    column :city
  end
end
