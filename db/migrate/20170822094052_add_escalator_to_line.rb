class AddEscalatorToLine < ActiveRecord::Migration[5.1]
  def change
    add_column :lines, :escalator, :float
  end
end
