class Admin::CasesController < ApplicationController
  def index
    @cases = current_user.cases
    @case = Case.new
    @light_sidebar  = true
  end

  def new
    @case = Case.new
  end

  def create
    @case = Case.new(case_params)
    @case.status = "Unpublished"
    @case.user = current_user
    if @case.save
      respond_to do |format|
        format.js
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
     @expvariables = @case.variables.where(category: "expert", state: true)
     @chartM = charts[:chartM]
     @chartA = charts[:chartA]
     @chartB = charts[:chartB]
  end

  def saveinputbuilder
    @case = Case.find(params[:id])
    @case.update(case_params_input)
    update_input_variables(@case)
    @expvariables = @case.variables.where(category: "expert", state: true)
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
    @case.update(status: "Published")
  end

  def savevariables
    @case = Case.find(params[:id])
    vars = JSON.parse(case_params_variables[:variablesjson])
    newexpertvars = vars.select { |num,val|  val[0] != "@" }.keys
    oldexpertvars = Variable.where(case_id: params[:id], category: "expert").map(&:name)
    add = newexpertvars - oldexpertvars
    add.each do |a|
      Variable.create(name: a, expression: vars[a], category: "expert", case_id: @case.id, state: true)
    end
    disablevars = oldexpertvars - newexpertvars
    # disablevars.each do |disvar|
    #   Variable.where(case_id: @case.id, category: "expert", name: disvar).update_all(state: false)
    # end
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
      mmin = [mydata[:Atotal].min, mydata[:Btotal].min].min - 5
      mmax = [mydata[:Atotal].max, mydata[:Btotal].max].max + 5

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
      mmin = [mydata[:Atotal].min, mydata[:Btotal].min].min.round - 5
      mmax = [mydata[:Atotal].max, mydata[:Btotal].max].max.round + 5


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
    regex = /(?:@[a-zA-Z]+)/
    newvars = mycase.user_input_text.scan(regex)
    oldvars = mycase.variables.where(category: "input").map(&:expression)
    add = newvars - oldvars
    disab = oldvars - newvars
    add.length > 0 ? addvariables(add, mycase) : nil
    disab.length > 0 ? disablevariables(delete, mycase) : nil
  end

  def addvariables(addarr, mycase)
    addarr.each do |add|
      Variable.create(name: add, expression: add, category: "input", case_id: mycase.id, state: true)
    end
  end

  def disablevariables(delarr, mycase)
    delarr.each do |del|
      mycase.variables.where(category: "input", expression: del).update(state: false)
    end
  end

end
