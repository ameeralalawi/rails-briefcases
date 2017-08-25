class Admin::LinesController < ApplicationController
  def create
    @case = Case.find(params[:id])
    @line = Line.new(line_params)
    @variable = Variable.where("case_id = ? AND name = ?", @case, params[:variable]).take
    @line.case = @case
    @line.variable = @variable
    if @line.save
      respond_to do |format|
        format.html { redirect_to case_path(@case) }
        format.js
      end
    else
          byebug
      respond_to do |format|
        format.html { render 'cases/show' }
        format.js
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def line_params
    params.permit(:name, :scenario, :category,  :recurrence, :start_date, :end_date, :escalator)
  end
end




