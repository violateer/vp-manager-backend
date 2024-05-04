class RemakeProjectsUsers < ActiveRecord::Migration[7.1]
  def change
    drop_table :projects_users

    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
  end
end
