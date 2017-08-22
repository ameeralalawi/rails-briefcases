class Admin::CasesController < ApplicationController
  def index
  end

  def create
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
