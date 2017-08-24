class Admin::CasesController < ApplicationController
  def index
  end

  def create
    # @case = Case.new

  end

  def delete
  end

  def show
     @case = Case.find(params[:id])
     @line = Line.new
  end

  def saveinputbuilder
    # @case = Case.new
    # @case.user = current_user
    # @input = case_params["user_input_text"]
    # @case.user_input_text = @input
    # #raise
    # if @case.save

    #   redirect_to admin_case_path(@case)
    # end

  end

  def saveoutputbuilder
  end

  def outputpreferences
  end

  def testdata
  end

  def updatestatus
  end

  private

  def case_params
     params.require(:case).permit(:user_input_text)

  end

end
