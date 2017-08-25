class Admin::LinesController < ApplicationController
  def create
    @case = Case.find(params[:case_id])
    @line = Line.new(line_params)
    @line.case = @case
    bool_new = @line.save
    if bool_new
      @chart = prep_chart(@case)
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
      @chart = prep_chart(@case)
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
      @chart = prep_chart(@case)
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

  private

  def prep_chart(mycase)
    mydata = mycase.build
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
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
  end

  def prep_chart_globals
    @chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
      f.global(useUTC: false)
      f.chart(
        backgroundColor: {
          linearGradient: [0, 0, 500, 500],
          stops: [
            [0, "rgb(255, 255, 255)"],
            [1, "rgb(240, 240, 255)"]
          ]
        },
        borderWidth: 3,
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#0B132B", "#CCCCCC", "#8085e9", "#f15c80", "#e4d354"])
    end
  end

  def line_params
    params.permit(:name, :variable_id, :scenario, :category, :recurrence, :start_date, :end_date, :escalator)
  end
end




