class Line < ApplicationRecord
  belongs_to :variable
  belongs_to :case

  validates :name, presence: true
  validates :variable_id, presence: true
  validates :case_id, presence: true
  validates :scenario, presence: true
  validates :category, presence: true, inclusion: { in: ["cost", "revenue"] }
  validates :recurrence, presence: true, inclusion: { in: ["oneoff", "monthly", "quaterly", "yearly"] }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :escalator, presence: true

   def default_values
    self.escalator ||= 0 # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end



end
