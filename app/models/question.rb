class Question < ActiveRecord::Base
  translates :text
  belongs_to :contest

  has_many :answers, dependent: :destroy
end
