class Case < ApplicationRecord
  belongs_to :user
  has_many :leads
  has_many :lines
  has_many :variables

  validates :status, presence: true
  validates :name, presence: true
  validates :user_id, presence: true
  validates :scenario_a, presence: true
  validates :scenario_b, presence: true
  validates :output_pref_1, inclusion: { in: [true, false] }
  validates :output_pref_2, inclusion: { in: [true, false] }
  validates :output_pref_3, inclusion: { in: [true, false] }
  validates :output_pref_4, inclusion: { in: [true, false] }
  validates :output_pref_5, inclusion: { in: [true, false] }
  validates :output_pref_6, inclusion: { in: [true, false] }


    def default_values
    self.status ||= 'unpublished' # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

end
