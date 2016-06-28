class Tag < ActiveRecord::Base
  belongs_to :tagged, polymorphic: true
end
