require 'faker'

puts 'Cleaning database...'
User.destroy_all
Case.destroy_all
Lead.destroy_all
VariableUse.destroy_all
Variable.destroy_all
Line.destroy_all

# A Single User is added to the App
User.create({
  :firstname => "Mr. John",
  :lastname => "Smith",
  :email => "test@test.com",
  :password => "password",
  :photo_url => "http://res.cloudinary.com/charlescazals/image/upload/v1502900804/luenmvsw4kamlpib7tai.jpg"
})

admin = User.last

# Two cases are added to the app. One which will be populated the other which will be just for show.
Case.create({
  :status => "published",
  :user_input_text => "I have #(TotalUserBulbs)# incandencent lightbulbs with a wattage of #(UserBulbWattage)# Watts in my home. My electricity price in USD per Kwh is: #(UserElecPrice)##()#. On average I keep my lights on #(UserHoursOfUse)# hours per day (average in Europe is 5 hours per day).",
  :user_output_text => "By investing a moderate amount as described above in Gen-X Hooli CFL 15 UltraMax type lightbulbs you can save $(NPV@Y2)$ USD in two years. Further, your investment will payback in $(BreakevenMonth)$ months",
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

Case.create({
  :status => "unpublished",
  :user_input_text => "",
  :user_output_text => "",
  :name => "Hooli CFL Lightbulb",
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

# Ten leads are added to the only "published" case.
20.times do {
  Lead.create({
  :case_id => seedcase.id,

  :user_id => admin.id})
}
