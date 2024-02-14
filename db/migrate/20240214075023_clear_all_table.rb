class ClearAllTable < ActiveRecord::Migration[7.1]
  def change
    # 禁用外键约束
    execute "ALTER TABLE projects DISABLE TRIGGER ALL;"
    execute "ALTER TABLE users DISABLE TRIGGER ALL;"

    # 清空表数据
    Menu.delete_all
    Project.delete_all
    User.delete_all

    # 启用外键约束
    execute "ALTER TABLE projects ENABLE TRIGGER ALL;"
    execute "ALTER TABLE users ENABLE TRIGGER ALL;"
  end
end
