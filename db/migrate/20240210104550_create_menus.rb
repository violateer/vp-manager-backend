class CreateMenus < ActiveRecord::Migration[7.1]
  def change
    create_table :menus do |t|
      t.string :old_id
      t.string :name
      t.integer :project_id
      t.integer :parent_id
      t.integer :level

      t.timestamps
    end
  end
end
