class AddSequToMenus < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :sequ, :integer

    # 创建序列
    execute <<-SQL
      CREATE SEQUENCE menus_sequ_seq OWNED BY menus.sequ;
    SQL

    # 设置默认值为序列的下一个值
    execute <<-SQL
      ALTER TABLE menus ALTER COLUMN sequ SET DEFAULT nextval('menus_sequ_seq');
    SQL
  end
end
