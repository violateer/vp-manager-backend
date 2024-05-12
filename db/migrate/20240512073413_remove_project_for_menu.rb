class RemoveProjectForMenu < ActiveRecord::Migration[7.1]
  def change
    remove_column :menus, :project_id # 删除列
  end
end
