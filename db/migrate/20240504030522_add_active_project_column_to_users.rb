class AddActiveProjectColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :active_project_id, :integer # users添加当前项目
    add_column :projects, :manager_user_id, :integer  # projects添加管理员id  

    drop_table :projects_users # 删除外键表，重新建一个没有外键的

    create_table :projects_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
  end
end
