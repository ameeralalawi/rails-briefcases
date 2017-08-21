class Case < ApplicationRecord
  belongs_to :user
  has_many :leads
  has_many :lines
  has_many :variables
end
