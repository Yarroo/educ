ActiveAdmin.register School do
  menu false
  active_admin_import validate: true,
                      before_batch_import: proc { |import|
                        scrubber = CsvScrubber.new(import)
                        scrubber.scrub
                      }

  actions :index, :show

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
  end
end
