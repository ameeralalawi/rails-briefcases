class Admin::CasesController < ApplicationController
  def index
    @cases = Case.all
    @case = Case.new
    @light_sidebar  = true
  end

  def new
    @case = Case.new
  end

  def create
    @case = Case.new(case_params)
    @case.status = "unpublished"
    @case.user = current_user
    if @case.save
      respond_to do |format|
        format.html { redirect_to admin_case_path(@case) }
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def delete
  end

  def show
     @case = Case.find(params[:id])
     @line = Line.new
     @chart_globals = prep_chart_globals
     charts = prep_chart(@case)
     @chartM = charts[:chartM]
     @chartA = charts[:chartA]
     @chartB = charts[:chartB]
  end

  def saveinputbuilder
    @case = Case.find(params[:id])
    @case.update(case_params_input)
    @variables = @case.variables.where(:category == "expert")
    # update_input_variables(@case)

    respond_to do |format|
      format.js
    end
  end

  def saveoutputbuilder
    @case = Case.find(params[:id])
    @case.update(case_params_output)
  end

  def outputpreferences
  end

  def testdata
    @case = Case.find(params[:id])
    case_params_testdata(@case).each do |varname,expertval|
      unless expertval.blank?
        changevar = Variable.where(case_id: params[:id], category: "input", name: varname)
        changevar.update(expert_value: expertval.to_f)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def updatestatus
    @case = Case.find(params[:id])
    @case.update(status: "published")
  end

  def savevariables
    @case = Case.find(params[:id])
    vars = JSON.parse(case_params_variables[:variablesjson])
    # vars.each do |varname, varvalue|
    #   if varvalue[0] == "@"
    #     Variable.where(case_id: params[:id], name: varname).destroy_all
    #     Variable.create(name: varname, expression: varvalue, case_id: @case.id, category: "input")
    #   else
    #     Variable.where(case_id: params[:id], name: varname).destroy_all
    #     Variable.create(name: varname, expression: varvalue, case_id: @case.id, category: "expert")
    #   end
    # end
    Variable.where(case_id: params[:id], category: "output").destroy_all
    @case.output_pref_1 ? Variable.create(name: "@B-A_EndofPeriod_Val", expression: "@B-A_EndofPeriod_Val", category: "output", case_id: @case.id) : nil
    @case.output_pref_2 ? Variable.create(name: "@A-B_EndofPeriod_Val", expression: "@A-B_EndofPeriod_Val", category: "output", case_id: @case.id) : nil
    @case.output_pref_3 ? Variable.create(name: "@Return_on_Invested_Capital", expression: "@Return_on_Invested_Capital", category: "output", case_id: @case.id) : nil
    @case.output_pref_4 ? Variable.create(name: "@Internal_Rate_Return", expression: "@Internal_Rate_Return", category: "output", case_id: @case.id) : nil
    @case.output_pref_5 ? Variable.create(name: "@First_Breakeven_in_months", expression: "@First_Breakeven_in_months", category: "output", case_id: @case.id) : nil
    @case.output_pref_6 ? Variable.create(name: "@Second_Breakeven_in_months", expression: "@Second_Breakeven_in_months", category: "output", case_id: @case.id) : nil
    respond_to do |format|
      format.js
    end
  end


  private

  def prep_chart(mycase)
    mydata = mycase.build
    chartM = LazyHighCharts::HighChart.new('graph1') do |f|
      f.title(text: mycase.name)
      f.xAxis(categories: mydata[:xaxis])
      f.series(name: mycase.scenario_a, yAxis: 0, data: mydata[:Atotalc])
      f.series(name: mycase.scenario_b, yAxis: 0, data: mydata[:Btotalc])
      f.yAxis [
        {title: {text: "EUR", margin: 0} }
      ]

      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.chart({defaultSeriesType: "line"})
    end
    chartA = LazyHighCharts::HighChart.new('graph2') do |f|
      f.title(text: mycase.scenario_a)
      f.xAxis(categories: mydata[:xaxis])
      mmin = [mydata[:Atotal].min, mydata[:Btotal].min].min - 10
      mmax = [mydata[:Atotal].max, mydata[:Btotal].max].max + 10

      mydata[:A].each do |graphlabel, graphdata|
        f.series(name: graphlabel, yAxis: 0, data: graphdata)
      end

      f.yAxis [
        {title: {text: "EUR", margin: 0}, min: mmin , max: mmax  }
      ]
      f.plotOptions(column: { stacking: 'normal'})
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.chart({defaultSeriesType: "column", height: '250'})
    end
    chartB = LazyHighCharts::HighChart.new('graph3') do |f|
      f.title(text: mycase.scenario_b)
      f.xAxis(categories: mydata[:xaxis])
      mmin = [mydata[:Atotal].min, mydata[:Btotal].min].min.round - 10
      mmax = [mydata[:Atotal].max, mydata[:Btotal].max].max.round + 10


      mydata[:B].each do |graphlabel, graphdata|
        f.series(name: graphlabel, yAxis: 0, data: graphdata)
      end

      f.yAxis [
        {title: {text: "EUR", margin: 0}, min: mmin , max: mmax }
      ]
      f.plotOptions(column: { stacking: 'normal'})
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.chart({defaultSeriesType: "column", height: '250'})
    end
    return {chartM: chartM ,chartA: chartA ,chartB: chartB}
  end

  def prep_chart_globals
    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(255, 255, 255)"]
          ]
        },
      )
      f.lang(thousandsSep: ",")
      f.colors(["#0B132B", "#CCCCCC", "#8085e9", "#f15c80", "#e4d354"])
    end
  end


  def case_params
     params.require(:case).permit(:user_input_text, :name, :scenario_a, :scenario_b)
  end

  def case_params_input
     params.require(:case).permit(:user_input_text)
  end

  def case_params_output
     parameters = {}
     parameters.merge!(params.require(:case).permit(:user_output_text))
     parameters.merge!(params.permit(:output_pref_1, :output_pref_2, :output_pref_3, :output_pref_4, :output_pref_5, :output_pref_6))
     parameters["output_pref_1"] ||= false
     parameters["output_pref_2"] ||= false
     parameters["output_pref_3"] ||= false
     parameters["output_pref_4"] ||= false
     parameters["output_pref_5"] ||= false
     parameters["output_pref_6"] ||= false
     return parameters
  end

  def case_params_variables
     params.permit(:variablesjson)
  end

  def case_params_testdata(mycase)
     list_params_allowed = mycase.variables.where(case_id: params[:id], category: "input").map(&:expression)
     params.permit(list_params_allowed)
  end

  def update_input_variables(mycase)
    raise
    regex = /(?:@[a-zA-Z]+)/
    newvars = mycase.user_input_text.scan(regex)
    oldvars = mycase.variables.where(category: "input").map(&:expression)
    add = newvars - oldvars
    delete = oldvars - newvars
    add.length > 0 ? addvariables(add, mycase) : nil
    delete.length > 0 ? deletevariables(delete, mycase) : nil
  end

  def addvariables(addarr, mycase)
    addarr.each do |add|
      Variable.create(name: add, expression: add, category: "input", case_id: mycase.id)
    end
  end

  def deletevariables(delarr, mycase)
    raise
    delarr.each do |del|
      mycase.variables.where(category: "input", expression: del).destroy_all
    end
  end

end
