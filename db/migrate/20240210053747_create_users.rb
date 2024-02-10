class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone
      t.string :password
      t.string :name
      t.string :avatar

      t.timestamps
    end
  end
end
