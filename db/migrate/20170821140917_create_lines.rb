class CreateLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.string :name
      t.string :scenario
      t.string :category
      t.string :recurrence
      t.date :start_date
      t.date :end_date
      t.references :variable, foreign_key: true
      t.references :case, foreign_key: true

      t.timestamps
    end
  end
end
