ActiveAdmin.register City do
  menu false

  actions :index, :show

  config.sort_order = 'name_asc'

  filter :name
  filter :district
  filter :region

  index do
    selectable_column
    id_column
    column :name
    column :population
    column :district
    column :region
    column :schools_count, sortable: :schools_count do |city|
      link_to city&.schools_count, admin_schools_path(q: { city_id_eq: city.id })
    end
  end

  show do
    attributes_table do
      row :name
      row :population
      row :district
      row :region
      row :schools do
        table_for resource.schools do
          column :id
          column :name
          column :short_name
          column :director
          column :phones
          column :email
          column :site
        end
      end
    end
  end
end
