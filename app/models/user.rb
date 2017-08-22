class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :cases

  validates :email, uniqueness: true, presence: true
  # validates :firstname, presence: true
  # validates :lastname, presence: true
end
