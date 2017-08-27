class Line < ApplicationRecord
  belongs_to :variable
  belongs_to :case

  validates :name, presence: true, uniqueness: { scope: :case_id,
    message: "Variable names should be unique within a single case" }
  validates :variable_id, presence: true
  validates :case_id, presence: true
  validates :scenario, presence: true
  validates :category, presence: true, inclusion: { in: ["cost", "revenue"] }
  validates :recurrence, presence: true, inclusion: { in: ["oneoff", "monthly", "quarterly", "yearly"] }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :escalator, presence: true

  def default_values
    self.escalator ||= 0 # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
  end

  def build(extents)
    # Initialize this line to its own extents
    lineext = self.recurrence == "oneoff" ? 1 : (self.end_date.year * 12 + self.end_date.month) - (self.start_date.year * 12 + self.start_date.month)
    myline = Array.new(lineext, 0)
    # Load line characteristics
    category = self.category == "cost" ? -1 : 1
    arr = ["oneoff", "monthly", "quarterly", "yearly"]
    recurrence = [9999.0,1.0,3.0,12.0][arr.size.times.select {|i| arr[i] == self.recurrence}.first]
    reccadj = [9999.0,12.0,4.0,1.0][arr.size.times.select {|i| arr[i] == self.recurrence}.first]
    effectiveesc = ((1.0 + (self.escalator/100.0))**(1.0/reccadj))-1.0
    variable_value = self.variable.eval_var * category

    # Fill line
    idx = 0
    while idx <= lineext-1
      myline[idx] = variable_value
      variable_value *= (1 + effectiveesc)
      idx += recurrence
    end

    payload = Array.new(extents[:months], 0)
    offset = (self.start_date.year * 12 + self.start_date.month) - (extents[:absstart].year * 12 + extents[:absstart].month)
    payload[offset,lineext] = myline
    return {self.name.to_sym => payload}
  end

end
