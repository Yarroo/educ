ActiveAdmin.register School do
  menu false
  active_admin_import validate: true,
                      before_batch_import: proc { |import|
                        scrubber = CsvScrubber.new(import)
                        scrubber.scrub
                      }

  filter :city, collection: proc {City.includes(:schools).where.not(schools: {id: nil}).pluck(:name, :id).uniq}

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
end
