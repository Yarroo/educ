ActiveAdmin.register Region do
  menu false

  config.sort_order = 'name_asc'

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :code
    column :city_count do |region|
      link_to region&.cities&.count, admin_cities_path(q: { region_id_eq: region.id })
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :code
      row :cities
    end
  end

end
