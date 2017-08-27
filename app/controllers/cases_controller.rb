class CasesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @case = Case.find(params[:id])
    unless @case.status == "published"
      flash[:notice] = "This case has not been published"
      redirect_to root_path
      return
    end
  end
end
