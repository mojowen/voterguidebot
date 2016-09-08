class ExportGuide < ActiveRecord::Base
  belongs_to :guide
  belongs_to :export

  validates :export, presence: true
  validates :guide, presence: true
end
