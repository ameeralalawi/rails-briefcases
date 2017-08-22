class Lead < ApplicationRecord
  belongs_to :case
  has_many :variable_uses
  has_many :variables, through: :variable_uses

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true

end
