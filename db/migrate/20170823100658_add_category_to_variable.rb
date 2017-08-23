class AddCategoryToVariable < ActiveRecord::Migration[5.1]
  def change
    add_column :variables, :category, :string
  end
end
