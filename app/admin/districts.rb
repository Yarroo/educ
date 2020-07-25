ActiveAdmin.register District do
  menu false

  config.sort_order = 'name_asc'

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :short_name
    column :code
    column (:regions_count) { |district| district&.regions&.count }
    column (:cities_count) { |district| district&.regions.reduce(0){ |memo, elm| memo + elm.cities&.count }}
    actions
  end
end
