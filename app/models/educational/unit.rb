class Educational::Unit < ApplicationRecord
  belongs_to :region, class_name: 'Region'
  has_and_belongs_to_many :programs, class_name: 'Educational::Program'
  has_many :levels, :class_name => 'Educational::Level', through: :programs
  has_one :district, class_name: 'District', through: :region

end
