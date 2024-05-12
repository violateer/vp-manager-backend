class AddRouteAndTypeToMenu < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :route, :string 
    add_column :menus, :type, :string 
  end
end
