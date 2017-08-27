class Case < ApplicationRecord
  belongs_to :user
  has_many :leads
  has_many :lines
  has_many :variables

  # validates :status, presence: true
  # validates :name, presence: true
  # validates :user_id, presence: true
  # validates :scenario_a, presence: true
  # validates :scenario_b, presence: true
  # validates :output_pref_1, inclusion: { in: [true, false] }
  # validates :output_pref_2, inclusion: { in: [true, false] }
  # validates :output_pref_3, inclusion: { in: [true, false] }
  # validates :output_pref_4, inclusion: { in: [true, false] }
  # validates :output_pref_5, inclusion: { in: [true, false] }
  # validates :output_pref_6, inclusion: { in: [true, false] }


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
    mycase[:A].empty? ? mycase[:A].merge!({"NODATA".to_sym => Array.new([extents[:months],1].max, 0)}) : nil
    mycase[:B].empty? ? mycase[:B].merge!({"NODATA".to_sym => Array.new([extents[:months],1].max, 0)}) : nil
    totalarray = []
    mycase[:A].each do |name,line|
      totalarray << line
    end
    mycase[:Atotal] = totalarray.transpose.map {|i| i.reduce(:+)}
    mycase[:Atotalc] = mycase[:Atotal].inject([]) { |x, y| x + [(x.last || 0) + y] }
    totalarray = []
    mycase[:B].each do |name,line|
      totalarray << line
    end
    mycase[:Btotal] = totalarray.transpose.map {|i| i.reduce(:+)}
    mycase[:Btotalc] = mycase[:Btotal].inject([]) { |x, y| x + [(x.last || 0) + y] }
    mycase[:CaseDelta] = [mycase[:Atotalc],mycase[:Btotalc]].transpose.map {|i| i.reduce(:-)}
    return mycase
  end

  def determine_extents
    if self.lines.empty?
      m_start = Date.today
      m_end = Date.today.next_year
    else
      m_start = self.lines.first.start_date
      m_end = self.lines.first.end_date
      self.lines.each do |line|
        line.start_date < m_start ? m_start = line.start_date : nil
        line.end_date > m_end ? m_end = line.end_date : nil
      end
    end
    return {absstart: m_start, absend: m_end, months:(m_end.year * 12 + m_end.month) - (m_start.year * 12 + m_start.month)}
  end

  def output
    out = {}
    build = self.build
    self.output_pref_1 ? out[:output_pref_1] = b_over_a_value_at_eop(build) : nil
    self.output_pref_2 ? out[:output_pref_2] = a_over_b_value_at_eop(build) : nil
    self.output_pref_3 ? out[:output_pref_3] = 0 : nil
    self.output_pref_4 ? out[:output_pref_4] = 0 : nil
    self.output_pref_5 ? out[:output_pref_5] = cross_over_months(build) : nil
    self.output_pref_6 ? out[:output_pref_6] = 0 : nil
    return out
  end

  def b_over_a_value_at_eop(build)
  end

  def a_over_b_value_at_eop(build)
    return build[:CaseDelta].last
  end

  def cross_over_months(build)
    return build[:CaseDelta].find_index{|x| x >= 0 } + 1
  end
end
