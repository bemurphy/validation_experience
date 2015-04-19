class Book < ActiveRecord::Base
  include ValidationExperience::Model

  belongs_to :author

  validates :title, presence: true
  validates :publishing_year, presence: true
end
