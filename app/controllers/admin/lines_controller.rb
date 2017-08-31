class Admin::LinesController < ApplicationController
  def create
    @case = Case.find(params[:case_id])
    @line = Line.new(line_params)
    @line.case = @case
    bool_new = @line.save
    if bool_new
      charts = prep_chart(@case)
      @chartM = charts[:chartM]
      @chartA = charts[:chartA]
      @chartB = charts[:chartB]
      @chart_globals = prep_chart_globals
    end
    if bool_new
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @case = Case.find(params[:case_id])
    @line = Line.find(params[:id])
    bool_upd = @line.update(line_params)
    if bool_upd
      charts = prep_chart(@case)
      @chartM = charts[:chartM]
      @chartA = charts[:chartA]
      @chartB = charts[:chartB]
      @chart_globals = prep_chart_globals
    end
    if bool_upd
      respond_to do |format|
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
    @case = Case.find(params[:case_id])
    @line = Line.find(params[:id])
    @line_id = @line.id
    bool_dest = @line.destroy
    if bool_dest
      charts = prep_chart(@case)
      @chartM = charts[:chartM]
      @chartA = charts[:chartA]
      @chartB = charts[:chartB]
      @chart_globals = prep_chart_globals
    end
    if @line.destroy
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def reloadnewform
    @case = Case.find(params[:case_id])
    respond_to do |format|
      format.js
    end
  end

  private

  def prep_chart(mycase)
    mydata = mycase.build
    chartM = LazyHighCharts::HighChart.new('graph1') do |f|

      f.xAxis(categories: mydata[:xaxis])
      f.series(name: mycase.scenario_a, yAxis: 0, data: mydata[:Atotalc])
      f.series(name: mycase.scenario_b, yAxis: 0, data: mydata[:Btotalc])
      f.yAxis [
        {title: {text: "EUR", margin: 0} }
      ]

      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0, layout: 'horizontal')
      f.chart({defaultSeriesType: "line", backgroundColor: '#F4F4F4'})
    end
    chartA = LazyHighCharts::HighChart.new('graph2') do |f|

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
      f.chart({defaultSeriesType: "column", height: '250', backgroundColor: '#F4F4F4'})
    end
    chartB = LazyHighCharts::HighChart.new('graph3') do |f|

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
      f.chart({defaultSeriesType: "column", height: '250', backgroundColor: '#F4F4F4'})
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
            [0, "rgb(244, 244, 244)"],
            [1, "rgb(244, 244, 244)"]
          ]
        },
      )
      f.lang(thousandsSep: ",")
      f.colors(["#3a506b", "#5bc0be", "#8085e9", "#f15c80", "#e4d354"])
    end
  end

  def line_params
    params.permit(:name, :variable_id, :scenario, :category, :recurrence, :start_date, :end_date, :escalator)
  end
end




