class RemoveForeignKeyFromUsersAndProjects < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :projects, :users, column: :manager_user_id
    remove_foreign_key :users, :projects, column: :active_project_id
  end
end
