ActiveAdmin.register Educational::Unit do
  menu false

  filter :levels, as: :select, input_html: { multiple: true }
  filter :region, as: :select, input_html: { multiple: true }
  filter :district, as: :select, input_html: { multiple: true }
  filter :name
  filter :uuid

  index do
    selectable_column
    id_column
    column :uuid
    column :name
    column :short_name
    column :head_uuid
    column :branch
    column :address
    column :phone
    column :email
    column :site
    column :ogrn
    column :inn
    column :head_post
    column :head_name
    column :region
    column :district
    column :programs do |unit|
      unit&.programs.map{ |program| link_to program.title, admin_educational_program_path(program) }
    end
    column :levels
    actions
  end

end
