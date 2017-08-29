class Admin::LeadsController < ApplicationController
  def index
    @case = Case.find(params[:case_id])
  end
end
