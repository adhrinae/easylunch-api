class CreateUserMessengers < ActiveRecord::Migration
  def change
    create_table :user_messengers do |t|
      t.references :user
      t.integer :messenger_code
      t.string :messenger_user_id

      t.timestamps null: false
    end
    add_index :user_messengers, :user_id
    add_foreign_key :user_messengers, :code_tables, column: :messenger_code
  end
end
