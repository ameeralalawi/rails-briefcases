class VariableUse < ApplicationRecord
  belongs_to :lead
  belongs_to :variable

  validates :variable_id, presence: true
  validates :value, presence:true
end
