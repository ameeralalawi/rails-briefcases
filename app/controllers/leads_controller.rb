class LeadsController < ApplicationController
  skip_before_action :authenticate_user!


  def create
    @case = Case.find(params[:id])
    @lead = Lead.create(case: @case)

    @variables_names = params[:vars].keys

    @variables_names.each do |name|
      @variable_use = VariableUse.new(lead: @lead)
      @variable_use.variable = Variable.find_by(case_id: @case, category: "input", name: name)
      @variable_use.value = params[:vars][name]
      @variable_use.save!
    end

      @out = @case.output(@lead)
      charts = prep_chart(@case, @lead)
      @chartM = charts[:chartM]
      @chart_globals = prep_chart_globals

    respond_to do |format|

      @output_sentence = @case.user_output_text
      @out.each do |_k, value|
        @output_sentence = @output_sentence.sub(/(@\w+\b)/, value.round(1).to_s)
      end
      format.js  # <-- idem
    end
  end


  def update
    @lead = Lead.find(params[:id])
    @case = Case.find(@lead.case_id)
    if @lead.update(update_params)
     respond_to do |format|
      format.html { redirect_to case_path(@case) }
      format.js  # <-- idem
      end
    end
  end




private

  def update_params
    params.require(:lead).permit( :first_name, :last_name, :email )
  end

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



