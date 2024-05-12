class RenameTypeToMenu < ActiveRecord::Migration[7.1]
  def change
    remove_column :menus, :type
    add_column :menus, :route_type, :string
  end
end
