class CreateVariableUses < ActiveRecord::Migration[5.1]
  def change
    create_table :variable_uses do |t|
      t.float :value
      t.references :lead, foreign_key: true
      t.references :variable, foreign_key: true

      t.timestamps
    end
  end
end
