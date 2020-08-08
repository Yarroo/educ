ActiveAdmin.register School do
  menu false
  active_admin_import validate: true,
                      headers_rewrites: { 'city': :city_id },
                      before_batch_import: proc { |import|
                        scrubber = CsvScrubber.new(import)
                        scrubber.scrub
                      }

  filter :city, collection: proc {City.includes(:schools).where.not(schools: {id: nil}).pluck(:name, :id).uniq}, input_html: { multiple: true }

  permit_params :name, :short_name, :director, :address,
                :site, :city_id, email: [], phone: []


  index do
    selectable_column
    id_column

    column :name
    column :short_name
    column :director
    column (:email) { |school| school.email.map { |email| mail_to email }}
    column :address
    column :phone
    column :site do |school|
      school.site&.split(",")&.map do |link|
        link_to URI.decode(link), link
      end
    end
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
    column (:city) { |school| school&.city&.name }
    column :name
    column :short_name
    column :director
    column (:email) { |school| school.email.join(", ") }
    column :phone
    column :site
  end

  controller do
    def update
      email = params[:school][:email]&.split(",")
      phone = params[:school][:phone]&.split(",")
      params[:school][:email] = Array.wrap(email)
      params[:school][:phone] = Array.wrap(phone)
      super
    end
  end
end
