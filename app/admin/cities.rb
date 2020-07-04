ActiveAdmin.register City do
  actions :index, :show

  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :name
    column :population
    column :district
    column :region
  end
end
