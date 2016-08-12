module Stance
  extend ActiveSupport::Concern

  included do
    enum stance: %w{for against}
  end
end
