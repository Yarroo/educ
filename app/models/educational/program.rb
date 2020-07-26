class Educational::Program < ApplicationRecord
  belongs_to :program_type, class_name: 'Educational::ProgramType', optional: true
  belongs_to :ugs_code, class_name: 'Educational::UgsCode', optional: true
  belongs_to :level, class_name: 'Educational::Level', optional: true
  has_and_belongs_to_many :units, class_name: 'Educational::Unit'

  def title
    name || level&.name
  end

end
