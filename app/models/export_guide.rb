class ExportGuide < ActiveRecord::Base
  belongs_to :guide
  belongs_to :export

  validates :export, presence: true
  validates :guide, presence: true

  def is_failed?
    export_version == 'not-published'
  end

  def fail!
    update_attributes export_version: 'not-published'
  end
end
