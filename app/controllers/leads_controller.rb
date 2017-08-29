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
  end



  end
