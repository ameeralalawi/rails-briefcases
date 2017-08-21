class CreateVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :variables do |t|
      t.string :expression
      t.string :name
      t.float :expert_value
      t.references :case, foreign_key: true

      t.timestamps
    end
  end
end
