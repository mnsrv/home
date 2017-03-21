class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :string
      t.string :password_salt
      t.string :string

      t.timestamps
    end
  end
end
