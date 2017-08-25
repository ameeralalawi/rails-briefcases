class Admin::CasesController < ApplicationController
  def index
    @cases = Case.all
  end

  def create
    # @case = Case.new

  end

  def delete
  end

  def show
     @case = Case.find(params[:id])
     @line = Line.new
     @chart = prep_chart(@case)
     @chart_globals = prep_chart_globals
  end

  def saveinputbuilder
    # @case = Case.new
    # @case.user = current_user
    # @input = case_params["user_input_text"]
    # @case.user_input_text = @input
    # #raise
    # if @case.save

    #   redirect_to admin_case_path(@case)
    # end

  end

  def saveoutputbuilder
  end

  def outputpreferences
  end

  def testdata
  end

  def updatestatus
  end

  private

  def prep_chart(mycase)
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: mycase.name)
      f.xAxis(categories: ["JAN17", "FEB17", "MAR17", "APR17", "MAY17"])
      f.series(name: "Scenario A", yAxis: 0, data: [14119, 5068, 4985, 3339, 2656])
      f.series(name: "Scenario B", yAxis: 0, data: [310, 127, 1340, 81, 65])

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

  def case_params
     params.require(:case).permit(:user_input_text)

  end

end
