class AddManagerUserToProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :projects, :manager_user, null: false, foreign_key:  { to_table: :users }
  end
end
