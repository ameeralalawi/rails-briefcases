class Line < ApplicationRecord
  belongs_to :variable
  belongs_to :case
end
