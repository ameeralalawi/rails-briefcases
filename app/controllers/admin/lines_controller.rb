class Admin::LinesController < ApplicationController
  def create
    @case = Case.find(params[:case_id])
    @line = Line.new(line_params)
    @line.case = @case
    if @line.save
      respond_to do |format|
        format.html { redirect_to case_path(@case) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'cases/show' }
        format.js
      end
    end
  end

  def update
    @case = Case.find(params[:case_id])
    @line = Line.find(params[:id])
    if @line.update(line_params)
      respond_to do |format|
        format.html { redirect_to case_path(@case) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'cases/show' }
        format.js
      end
    end
  end

  def destroy
    @line = Line.find(params[:id])
    @line_id = @line.id
    if @line.destroy
      respond_to do |format|
        format.html { redirect_to case_path(@case) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'cases/show' }
        format.js
      end
    end
  end

  private

  def line_params
    params.permit(:name, :variable_id, :scenario, :category, :recurrence, :start_date, :end_date, :escalator)
  end
end




