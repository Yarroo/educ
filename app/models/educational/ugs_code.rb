class Educational::UgsCode < ApplicationRecord
  has_many :programs, :class_name => 'Educational::Program'
end
