class AddActiveProjectToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :active_project, null: true, foreign_key: { to_table: :projects }
  end
end
