class Lead < ApplicationRecord
  belongs_to :case
  has_many :variable_uses
  has_many :variables, through: :variable_uses
end
