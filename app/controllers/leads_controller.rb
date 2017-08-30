class LeadsController < ApplicationController
  skip_before_action :authenticate_user!


  def create
    @case = Case.find(params[:id])
    @lead = Lead.create(case: @case)

    @variables_names = params[:vars].keys

    @variables_names.each do |name|
      @variable_use = VariableUse.new(lead: @lead)
      @variable_use.variable = Variable.find_by(category: "input", name: name)
      @variable_use.value = params[:vars][name]
      @variable_use.save!
    end

    respond_to do |format|
      format.html { redirect_to case_path(@case) }
      format.js  # <-- idem
    end
  end


  def update
    @lead = Lead.find(params[:id])
    @case = Case.find(@lead.case_id)
    if @lead.update(update_params)
     respond_to do |format|
      format.html { redirect_to case_path(@case) }
      format.js  # <-- idem
      end
    end
  end

end

private
  def update_params
    params.require(:lead).permit( :first_name, :last_name, :email )
  end
