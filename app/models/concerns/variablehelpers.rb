module Variablehelpers
  def is_number? string
    no_commas =  string.to_s.gsub(',', '')
    true if Float(no_commas) rescue false
  end

  def regex_is_number? string
    no_commas =  string.gsub(',', '')
    matches = no_commas.match(/-?\d+(?:\.\d+)?/)
    if !matches.nil? && matches.size == 1 && matches[0] == no_commas
      true
    else
      false
    end
  end
end
