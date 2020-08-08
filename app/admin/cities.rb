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
    actions defaults: true do |city|
      if current_user.roles.include? "admin"
        link_to 'Очистить школы', delete_school_admin_city_path(city), method: :put,
                data: { confirm: 'Все школы будут удалены. Вы уверены?' }
      end
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

  action_item :only => :index do
    link_to('Обновить кол-во школ', reset_counters_admin_cities_path)
  end

  member_action :delete_school, method: :put do
    resource.delete_schools
    redirect_to collection_path, notice: "Очищены школы для города", method: :put
  end

  collection_action :reset_counters, method: :get do
    City.find_each do |city|
      City.reset_counters(city.id, :schools)
    end
    redirect_to collection_path, notice: "Счётчики обновлены"
  end
end
