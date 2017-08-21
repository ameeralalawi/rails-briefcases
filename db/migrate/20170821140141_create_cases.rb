class CreateCases < ActiveRecord::Migration[5.1]
  def change
    create_table :cases do |t|
      t.string :status
      t.string :user_input_text
      t.string :user_output_text
      t.string :name
      t.string :icon
      t.string :color
      t.string :scenario_a
      t.string :scenario_b
      t.boolean :output_pref_1
      t.boolean :output_pref_2
      t.boolean :output_pref_3
      t.boolean :output_pref_4
      t.boolean :output_pref_5
      t.boolean :output_pref_6
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
