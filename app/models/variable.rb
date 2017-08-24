class Variable < ApplicationRecord
  include VariableHelpers
  belongs_to :case
  has_many :lines
  has_many :variable_uses

  validates :name, presence: true
  validates :expression, presence: true
  validates :case_id, presence: true



  def eval_var
    case self.category
      when "input"
        # if user_signed_in?
          return self.expert_value
        # else
        #   VariableUse.where(variable_id: self.id, lead_id: @lead.id)
        # end
      when "expert"
        value = JSON.parse(self.expression)["data"]
        return eval_complex(self, value)
      when "output"
        puts 'unimplemented'
      else
        puts "Category Format Error!"
    end
  end

  def eval_complex(var_inst, value)
    prepared_expr = []
    value.each do |op|
      if op.is_a? String
        prepared_expr << op.to_s.gsub(',', '')
      elsif op.is_a? Hash
        if is_number? op["value"]
          prepared_expr << op["value"].to_s.gsub(',', '')
        else
          vari = Variable.where(name: op["value"], case_id: var_inst.case_id).first
          prepared_expr << vari.eval_var.to_s.gsub(',', '')
        end
      else
        prepared_expr << ".Err."
      end
    end
    return eval(prepared_expr.join)
  end
end
