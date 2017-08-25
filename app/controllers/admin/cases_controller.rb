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
     @chart = prep_chart
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

  def prep_chart
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Your Case")
      f.xAxis(categories: ["United States", "Japan", "China", "Germany", "France"])
      f.series(name: "GDP in Billions", yAxis: 0, data: [14119, 5068, 4985, 3339, 2656])
      f.series(name: "Population in Millions", yAxis: 1, data: [310, 127, 1340, 81, 65])

      f.yAxis [
        {title: {text: "GDP in Billions", margin: 70} },
        {title: {text: "Population in Millions"}, opposite: true},
      ]

      f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "column"})
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
        borderWidth: 2,
        plotBackgroundColor: "rgba(255, 255, 255, .9)",
        plotShadow: true,
        plotBorderWidth: 1
      )
      f.lang(thousandsSep: ",")
      f.colors(["#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354"])
    end
  end

  def case_params
     params.require(:case).permit(:user_input_text)

  end

end
