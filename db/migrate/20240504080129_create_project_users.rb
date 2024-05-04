class CreateProjectUsers < ActiveRecord::Migration[7.1]
  def change
    #之前手动建的表，这里删掉
    drop_table :project_users

    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
  end
end
