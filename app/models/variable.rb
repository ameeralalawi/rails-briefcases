class Variable < ApplicationRecord
  include VariableHelpers
  belongs_to :case
  has_many :lines, dependent: :destroy
  has_many :variable_uses, dependent: :destroy

  validates :name, presence: true
  validates :expression, presence: true
  validates :case_id, presence: true



  def eval_var(lead = nil)
    case self.category
      when "input"
        if lead == nil
          return self.expert_value
        else
          VariableUse.where(variable_id: self.id, lead_id: lead.id).take.value
        end
      when "expert"
        value = JSON.parse(self.expression)["data"]
        return eval_complex(self, value, lead)
      when "output"
        puts 'unimplemented'
      else
        puts "Category Format Error!"
    end
  end

  def eval_complex(var_inst, value, lead = nil)
    prepared_expr = []
    value.each do |op|
      if op.is_a? String
        prepared_expr << op.to_s.gsub(',', '')
      elsif op.is_a? Hash
        if op["type"] == "unit"
          prepared_expr << op["value"].to_s.gsub(',', '')
        elsif op["type"] == "item"
          if [String].member? op["value"].class
            vari = Variable.where(name: op["value"], case_id: var_inst.case_id).first
            prepared_expr << vari.eval_var(lead).to_s.gsub(',', '')
          elsif [Integer, Float, Numeric, Fixnum].member? op["value"].class
            prepared_expr << op["value"]
          elsif op["value"].is_a? Hash
            prepared_expr << eval_complex(var_inst, op["value"]["data"],lead)
          else
            raise
          end
        end
      else
        prepared_expr << ".Err."
      end
    end
    return eval(prepared_expr.join)
  end
end



