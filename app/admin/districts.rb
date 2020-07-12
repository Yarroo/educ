ActiveAdmin.register District do
  menu false

  actions :index, :show

  config.sort_order = 'name_asc'

  index do
    selectable_column
    id_column
    column :name
    column (:regions_count) { |district| district&.regions&.count }
    column (:cities_count) { |district| district&.regions.reduce(0){ |memo, elm| memo + elm.cities&.count }}
  end
end
