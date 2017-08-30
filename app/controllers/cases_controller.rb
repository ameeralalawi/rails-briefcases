class CasesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @case = Case.find(params[:id])
    unless @case.status == "Published"
      flash[:notice] = "This case has not been published"
      redirect_to root_path
      return
    end

      @lead = Lead.create(case: @case)

      @out = {output_pref_1: 999, output_pref_2: 999, output_pref_3: 999, output_pref_4: 999, output_pref_5: 999, output_pref_6: 999 }
      charts = prep_chart(@case)
      @chartM = charts[:chartM]
      @chart_globals = prep_chart_globals


      @input = @case.user_input_text
  end



private

  def prep_chart(mycase, lead = nil)
    mydata = mycase.build(lead)
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


    return {chartM: chartM}
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

end
