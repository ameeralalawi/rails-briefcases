class Variable < ApplicationRecord
  belongs_to :case
  has_many :lines
  has_many :variable_uses

  validates :name, presence: true
  validates :expression, presence: true
  validates :expert_value, presence: true
  validates :case_id, presence: true

end
