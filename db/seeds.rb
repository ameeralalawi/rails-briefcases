require 'faker'

puts 'Cleaning database...'
User.destroy_all
Case.destroy_all
Lead.destroy_all
VariableUse.destroy_all
Variable.destroy_all
Line.destroy_all


puts 'Seeding database...'
# A Single User is added to the App
User.create!({
  :firstname => "Mr. John",
  :lastname => "Smith",
  :email => "test@test.com",
  :password => "password",
  :photo_url => "http://res.cloudinary.com/charlescazals/image/upload/v1502900804/luenmvsw4kamlpib7tai.jpg"
})

admin = User.last

# Two cases are added to the app. One which will be populated the other which will be just for show.
Case.create!({
  :status => "published",
  :user_input_text => "I have #(TotalUserBulbs)# incandencent lightbulbs with a wattage of #(UserBulbWattage)# Watts in my home. My electricity price in USD per Kwh is: #(UserElecPrice)#. On average I keep my lights on #(UserHoursOfUse)# hours per day (average in Europe is 5 hours per day).",
  :user_output_text => "By investing a moderate amount as described above in Gen-X Hooli CFL 15 UltraMax type lightbulbs you can save $(NPVY2)$ USD in two years. Further, your investment will payback in $(BreakevenMonth)$ months",
  :name => "Hooli CFL Lightbulb",
  :icon => "fa-lightbulb-o",
  :color => "darkblue",
  :scenario_a => "Gen-X Hooli CFL 15 UltraMax",
  :scenario_b => "Regular Incandecent Lightbulbs",
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
 {:expression => '#(TotalUserBulbs)#',
  :name => 'TotalUserBulbs',
  :expert_value => 10,
  :case_id => seedcase.id},
 {:expression => '#(UserBulbWattage)#',
  :name => 'UserBulbWattage',
  :expert_value => 60,
  :case_id => seedcase.id},
 {:expression => '#(UserElecPrice)#',
  :name => 'UserElecPrice',
  :expert_value => 0.10,
  :case_id => seedcase.id},
 {:expression => '#(UserHoursOfUse)#',
  :name => 'UserHoursOfUse',
  :expert_value => 5,
  :case_id => seedcase.id},
 {:expression => '$(NPVY2)$',
  :name => 'NPVY2',
  :case_id => seedcase.id},
 {:expression => '$(BreakevenMonth)$',
  :name => 'BreakevenMonth',
  :case_id => seedcase.id},
 {:expression => '$(CostPerHooliBulb)$',
  :name => 'CostPerHooliBulb',
  :expert_value => 4.0,
  :case_id => seedcase.id},
 {:expression => '$(WattageHooliBulb)$',
  :name => 'WattageHooliBulb',
  :expert_value => 15,
  :case_id => seedcase.id},
 {:expression => '{"data":["(","(",{"value":"#(TotalUserBulbs)#","type":"item"},"*",{"value":"#(UserHoursOfUse)#","type":"item"},"*",{"value":"$(WattageHooliBulb)$","type":"item"},")","/",{"value":"1,000","type":"unit"},")","*",{"value":"#(UserElecPrice)#","type":"item"},"*","(",{"value":"365","type":"unit"},"/",{"value":"12","type":"unit"},")"],"filterData":{"status":true,"data":{"operator":"*","operand1":{"operator":"*","operand1":{"operator":"/","operand1":{"operator":"*","operand1":{"operator":"*","operand1":{"value":"#(TotalUserBulbs)#","type":"item"},"operand2":{"value":"#(UserHoursOfUse)#","type":"item"},"length":5},"operand2":{"value":"$(WattageHooliBulb)$","type":"item"},"length":5},"operand2":{"value":"1,000","type":"unit"},"length":9},"operand2":{"value":"#(UserElecPrice)#","type":"item"},"length":19},"operand2":{"operator":"/","operand1":{"value":"365","type":"unit"},"operand2":{"value":"12","type":"unit"},"length":3},"length":19}}}',
  :name => 'ScenarioA_CostpMonth',
  :case_id => seedcase.id},
 {:expression => '{"data":["(","(",{"value":"#(TotalUserBulbs)#","type":"item"},"*",{"value":"#(UserHoursOfUse)#","type":"item"},"*",{"value":"#(UserBulbWattage)#","type":"item"},")","/",{"value":"1,000","type":"unit"},")","*",{"value":"#(UserElecPrice)#","type":"item"},"*","(",{"value":"365","type":"unit"},"/",{"value":"12","type":"unit"},")"],"filterData":{"status":true,"data":{"operator":"*","operand1":{"operator":"*","operand1":{"operator":"/","operand1":{"operator":"*","operand1":{"operator":"*","operand1":{"value":"#(TotalUserBulbs)#","type":"item"},"operand2":{"value":"#(UserHoursOfUse)#","type":"item"},"length":5},"operand2":{"value":"#(UserBulbWattage)#","type":"item"},"length":5},"operand2":{"value":"1,000","type":"unit"},"length":9},"operand2":{"value":"#(UserElecPrice)#","type":"item"},"length":19},"operand2":{"operator":"/","operand1":{"value":"365","type":"unit"},"operand2":{"value":"12","type":"unit"},"length":3},"length":19}}}',
  :name => 'ScenarioB_CostpMonth',
  :case_id => seedcase.id},
 {:expression => '{"data":[{"value":"#(TotalUserBulbs)#","type":"item"},"*",{"value":"$(CostPerHooliBulb)$","type":"item"}],"filterData":{"status":true,"data":{"operator":"*","operand1":{"value":"#(TotalUserBulbs)#","type":"item"},"operand2":{"value":"$(CostPerHooliBulb)$","type":"item"},"length":3}}}',
  :name => 'InitialInvestment',
  :case_id => seedcase.id}
])

#Some helper jquery to use with pigno.se formula builder
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="#(TotalUserBulbs)#">TotalUserBulbs</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="#(UserBulbWattage)#">UserBulbWattage</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="#(UserElecPrice)#">UserElecPrice</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="#(UserHoursOfUse)#">UserHoursOfUse</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="$(CostPerHooliBulb)$">CostPerHooliBulb</a>')
# $('.formula-drop-items').append('<a href="#" class="formula-custom ui-draggable ui-draggable-handle" data-value="$(WattageHooliBulb)$">WattageHooliBulb</a>')

# Case lineitems are seeded here







# Twenty leads and 10 more empty responses are added to the only "published" case.
# Subsequently, fake form data is added to these leads
20.times do |x|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  Lead.create!({
    :case_id => seedcase.id,
    :first_name => first_name,
    :last_name => last_name,
    :email => "#{first_name}.#{last_name}@gmail.com"
    })
end
10.times do |x|
  Lead.create({
  :case_id => seedcase.id})
end

puts 'Finished!'
