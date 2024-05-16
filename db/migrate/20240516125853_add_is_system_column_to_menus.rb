class AddIsSystemColumnToMenus < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :is_system, :integer 
  end
end
