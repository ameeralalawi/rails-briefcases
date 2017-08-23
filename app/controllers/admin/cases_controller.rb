class Admin::CasesController < ApplicationController
  def index
  end

  def create
      @case = Case.new
    @case.user = current_user
    @input = params[:user_input_text]
    @case.user_input_text = @input
    @case.save
    raise
  end

  def delete
  end

  def show
     @case = Case.find(params[:id])
  end

  def saveinputbuilder

  end

  def saveoutputbuilder
  end

  def outputpreferences
  end

  def testdata
  end

  def updatestatus
  end
end
