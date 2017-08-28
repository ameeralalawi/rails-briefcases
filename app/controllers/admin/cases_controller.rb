class Admin::CasesController < ApplicationController
  def index
    @cases = Case.all
  end

  def create
    # @case = Case.new
    # @charts = prep_chart(@case)
    # charts = prep_chart(@case)
    # @chartM = charts[:chartM]
    # @chartA = charts[:chartA]
    # @chartB = charts[:chartB]
    # @chart_globals = prep_chart_globals
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
  end

  def saveoutputbuilder
    @case = Case.find(params[:id])
    @case.update(case_params_output)
  end

  def outputpreferences
  end

  def testdata
  end

  def updatestatus
    @case = Case.find(params[:id])
    @case.update(status: "published")
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
      f.chart({defaultSeriesType: "column", height: '320'})
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
      f.chart({defaultSeriesType: "column", height: '320'})
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

  def case_params_input
     params.require(:case).permit(:user_input_text)
  end

  def case_params_output
     params.require(:case).permit(:user_output_text)
  end

end
