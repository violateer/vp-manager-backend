class AddParentIdToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :parent_id, :integer # 新增列
  end
end
