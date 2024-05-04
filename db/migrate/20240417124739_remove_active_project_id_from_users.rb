class RemoveActiveProjectIdFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :active_project_id, :bigint
    remove_column :projects, :manager_user_id, :bigint
  end
end
