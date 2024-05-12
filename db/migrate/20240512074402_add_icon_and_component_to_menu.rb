class AddIconAndComponentToMenu < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :icon, :string # 新增列
    add_column :menus, :component, :string # 新增列
  end
end
