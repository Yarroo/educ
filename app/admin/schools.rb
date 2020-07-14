ActiveAdmin.register School do
  menu false
  active_admin_import validate: true,
                      headers_rewrites: { 'city': :city_id },
                      before_batch_import: proc { |import|
                        import.batch_slice_columns(['name', 'short_name', 'address', 'director', 'phone', 'email', 'site', :city_id ])
                        scrubber = CsvScrubber.new(import)
                        scrubber.scrub
                      }

  filter :city, collection: proc {City.includes(:schools).where.not(schools: {id: nil}).pluck(:name, :id).uniq}

  permit_params :name, :short_name, :director, :address, :phone,
                :site, :city_id, email: []


  index do
    selectable_column
    id_column

    column :name
    column :short_name
    column :director
    column (:email) { |school| school.email.map { |email| mail_to email }}
    column :address
    column :phone
    column :site
    column :city
    actions
  end

  # form do |f|
  #   f.inputs do
  #     f.input
  #
  #   end
  # end

  csv do
    column :id
    column (:city) { |school| school.city.name }
    column :name
    column :short_name
    column :director
    column (:email) { |school| school.email.join(", ") }
    column (:phone) { |school| school.phone.join(", ")}
    column :site
  end

  controller do
    def update
      email = params[:school][:email].split(",")
      params[:school][:email] = Array.wrap(email)
      super
    end
  end
end
