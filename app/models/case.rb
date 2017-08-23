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

  def build
    extents = determine_extents
    mycase = {}
    mycase[:A] = {}
    mycase[:B] = {}
    mycase[:xaxis] = (extents[:absstart]..extents[:absend]).map { |date| (date).strftime('%Y%m')}.uniq

    self.lines.each do |line|
      if line.scenario == "A"
        mycase[:A].merge!(line.build(extents))
      elsif line.scenario == "B"
        mycase[:B].merge!(line.build(extents))
      end
    end
    return mycase
  end

  def determine_extents
    m_start = self.lines.first.start_date
    m_end = self.lines.first.end_date
    self.lines.each do |line|
      line.start_date < m_start ? m_start = line.start_date : nil
      line.end_date > m_end ? m_end = line.end_date : nil
    end
    return {absstart: m_start, absend: m_end, months:(m_end.year * 12 + m_end.month) - (m_start.year * 12 + m_start.month)}
  end
end
