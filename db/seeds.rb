require 'faker'

puts 'Cleaning database...'
VariableUse.destroy_all
Line.destroy_all
Variable.destroy_all
Lead.destroy_all
Case.destroy_all
User.destroy_all


puts 'Seeding database...'
# A Single User is added to the App
User.create!({
  :first_name => "Mr. John",
  :last_name => "Smith",
  :email => "test@test.com",
  :password => "password",
  :title => "Senior Media Director"
})

admin = User.last

# Two cases are added to the app. One which will be populated the other which will be just for show.
Case.create!({
  :status => "published",
  :user_input_text => "I have @TotalUserBulbs incandescent lightbulbs with a wattage of @UserBulbWattage Watts in my home. My electricity price in USD per Kwh is: @UserElecPrice. On average I keep my lights on @UserHoursOfUse hours per day (average in Europe is 5 hours per day).",
  :user_output_text => "If you invest in our product, you will earn @ReturnOnInvestedCapital euros per year and recover the initial cost in @FirstBreakeveInMonths. In more details, the value of your investment after year one will be of @ABEndofPeriodVal. ",
  :name => "Hooli CFL Lightbulb",
  :icon => "fa-lightbulb-o",
  :color => "darkblue",
  :scenario_a => "Gen-X Hooli CFL 15 UltraMax",
  :scenario_b => "Regular Incandescent Lightbulbs",
  :output_pref_1 => false,
  :output_pref_2 => true,
  :output_pref_3 => false,
  :output_pref_4 => false,
  :output_pref_5 => true,
  :output_pref_6 => false,
  :user_id => admin.id
})

seedcase = Case.last

Case.create!({
  :status => "unpublished",
  :user_input_text => "",
  :user_output_text => "",
  :name => "Hooli eBike Campaign",
  :icon => "fa-bicycle",
  :color => "darkgreen",
  :scenario_a => "Hooli SuperMax E-bike 500Wh",
  :scenario_b => "Commute by metro",
  :output_pref_1 => false,
  :output_pref_2 => false,
  :output_pref_3 => false,
  :output_pref_4 => false,
  :output_pref_5 => false,
  :output_pref_6 => false,
  :user_id => admin.id
})

# Case variables are seeded here
Variable.create!([
 {:expression =>  '@TotalUserBulbs',
  :name => 'TotalUserBulbs',
  :expert_value => 10,
  :category => "input",
  :case_id => seedcase.id},
 {:expression =>  '@UserBulbWattage',
  :name => 'UserBulbWattage',
  :expert_value => 60,
  :category => "input",
  :case_id => seedcase.id},
 {:expression =>  '@UserElecPrice',
  :name => 'UserElecPrice',
  :expert_value => 0.10,
  :category => "input",
  :case_id => seedcase.id},
 {:expression =>  '@UserHoursOfUse',
  :name => 'UserHoursOfUse',
  :expert_value => 5,
  :category => "input",
  :case_id => seedcase.id},
 {:expression =>  '@NPVY2',
  :name => 'NPVY2',
  :category => "output",
  :case_id => seedcase.id},
 {:expression =>  '@BreakevenMonth',
  :name => 'BreakevenMonth',
  :category => "output",
  :case_id => seedcase.id},
 {:expression => '{"data":[{"value":4,"type":"item"}],"filterData":{"status":true,"data":{"value":4,"type":"item"}}}',
  :name => 'CostPerHooliBulb',
  :category => "expert",
  :case_id => seedcase.id},
 {:expression => '{"data":[{"value":15,"type":"item"}],"filterData":{"status":true,"data":{"value":15,"type":"item"}}}',
  :name => 'WattageHooliBulb',
  :category => "expert",
  :case_id => seedcase.id},
 {:expression => '{"data":["(","(",{"value":"TotalUserBulbs","type":"item"},"*",{"value":"UserHoursOfUse","type":"item"},"*",{"value":"WattageHooliBulb","type":"item"},")","/",{"value":"1,000","type":"unit"},")","*",{"value":"UserElecPrice","type":"item"},"*","(",{"value":"365","type":"unit"},"/",{"value":"12","type":"unit"},")"],"filterData":{"status":true,"data":{"operator":"*","operand1":{"operator":"*","operand1":{"operator":"/","operand1":{"operator":"*","operand1":{"operator":"*","operand1":{"value":"TotalUserBulbs","type":"item"},"operand2":{"value":"UserHoursOfUse","type":"item"},"length":5},"operand2":{"value":"WattageHooliBulb","type":"item"},"length":5},"operand2":{"value":"1,000","type":"unit"},"length":9},"operand2":{"value":"UserElecPrice","type":"item"},"length":19},"operand2":{"operator":"/","operand1":{"value":"365","type":"unit"},"operand2":{"value":"12","type":"unit"},"length":3},"length":19}}}',
  :name => 'ScenarioA_CostpMonth',
  :category => "expert",
  :case_id => seedcase.id},
 {:expression => '{"data":["(","(",{"value":"TotalUserBulbs","type":"item"},"*",{"value":"UserHoursOfUse","type":"item"},"*",{"value":"UserBulbWattage","type":"item"},")","/",{"value":"1,000","type":"unit"},")","*",{"value":"UserElecPrice","type":"item"},"*","(",{"value":"365","type":"unit"},"/",{"value":"12","type":"unit"},")"],"filterData":{"status":true,"data":{"operator":"*","operand1":{"operator":"*","operand1":{"operator":"/","operand1":{"operator":"*","operand1":{"operator":"*","operand1":{"value":"TotalUserBulbs","type":"item"},"operand2":{"value":"UserHoursOfUse","type":"item"},"length":5},"operand2":{"value":"UserBulbWattage","type":"item"},"length":5},"operand2":{"value":"1,000","type":"unit"},"length":9},"operand2":{"value":"UserElecPrice","type":"item"},"length":19},"operand2":{"operator":"/","operand1":{"value":"365","type":"unit"},"operand2":{"value":"12","type":"unit"},"length":3},"length":19}}}',
  :name => 'ScenarioB_CostpMonth',
  :category => "expert",
  :case_id => seedcase.id},
 {:expression => '{"data":[{"value":"TotalUserBulbs","type":"item"},"*",{"value":"CostPerHooliBulb","type":"item"}],"filterData":{"status":true,"data":{"operator":"*","operand1":{"value":"TotalUserBulbs","type":"item"},"operand2":{"value":"CostPerHooliBulb","type":"item"},"length":3}}}',
  :name => 'InitialInvestment',
  :category => "expert",
  :case_id => seedcase.id}
])

#Some helper jquery to use with pigno.se formula builder
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value= "@TotalUserBulbs">TotalUserBulbs</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value= "@UserBulbWattage">UserBulbWattage</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value= "@UserElecPrice">UserElecPrice</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value= "@UserHoursOfUse">UserHoursOfUse</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="$(CostPerHooliBulb)$">CostPerHooliBulb</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="$(WattageHooliBulb)$">WattageHooliBulb</a>')

# Case lineitems are seeded here

Line.create!([
 {:name => 'InitialInvestment',
  :scenario => 'A',
  :category => 'cost',
  :recurrence => 'oneoff',
  :start_date => '01/09/2017',
  :end_date => '01/09/2017',
  :variable_id => Variable.where("name = 'InitialInvestment'").first.id,
  :escalator => 0.0,
  :case_id => seedcase.id},
 {:name => 'ScenarioA_CostpMonth',
  :scenario => 'A',
  :category => 'cost',
  :recurrence => 'monthly',
  :start_date => '01/09/2017',
  :end_date => '01/09/2020',
  :variable_id => Variable.where("name = 'ScenarioA_CostpMonth'").first.id,
  :escalator => 0.0,
  :case_id => seedcase.id},
 {:name => 'ScenarioB_CostpMonth',
  :scenario => 'B',
  :category => 'cost',
  :recurrence => 'monthly',
  :start_date => '01/09/2017',
  :end_date => '01/09/2020',
  :variable_id => Variable.where("name = 'ScenarioB_CostpMonth'").first.id,
  :escalator => 0.0,
  :case_id => seedcase.id}
])

# Twenty leads and 10 more empty responses are added to the only "published" case.
# Subsequently, fake form data is added to these leads
20.times do |x|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  lead = Lead.create!({
    :case_id => seedcase.id,
    :first_name => first_name,
    :last_name => last_name,
    :email => "#{first_name}.#{last_name}@gmail.com"
  })
  VariableUse.create!([
 {:value => rand(4.0...50.0),
  :variable_id => Variable.where("name = 'TotalUserBulbs'").first.id,
  :lead_id => lead.id},
 {:value => [35.5, 40.0, 45.0, 50.0, 55.0, 60.0].sample,
  :variable_id => Variable.where("name = 'UserBulbWattage'").first.id,
  :lead_id => lead.id},
 {:value => rand(0.05...0.20),
  :variable_id => Variable.where("name = 'UserElecPrice'").first.id,
  :lead_id => lead.id},
 {:value => [3.0, 4.0, 5.0, 6.0, 7.0].sample,
  :variable_id => Variable.where("name = 'UserHoursOfUse'").first.id,
  :lead_id => lead.id}
  ])
end
8.times do |x|
  lead = Lead.create!({
  :case_id => seedcase.id
  })
  VariableUse.create!([
 {:value => rand(4.0...50.0),
  :variable_id => Variable.where("name = 'TotalUserBulbs'").first.id,
  :lead_id => lead.id},
 {:value => [35.5, 40.0, 45.0, 50.0, 55.0, 60.0].sample,
  :variable_id => Variable.where("name = 'UserBulbWattage'").first.id,
  :lead_id => lead.id},
 {:value => rand(0.05...0.20),
  :variable_id => Variable.where("name = 'UserElecPrice'").first.id,
  :lead_id => lead.id},
 {:value => [3.0, 4.0, 5.0, 6.0, 7.0].sample,
  :variable_id => Variable.where("name = 'UserHoursOfUse'").first.id,
  :lead_id => lead.id}
  ])
end

puts 'Finished!'
