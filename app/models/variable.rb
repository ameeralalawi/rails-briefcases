class Variable < ApplicationRecord
  belongs_to :case
  has_many :lines
  has_many :variable_uses
end
