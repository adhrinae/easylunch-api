class ChangeUserAndMessenger < ActiveRecord::Migration
  def change
    rename_column :users, :email, :service_uid
    add_column :user_messengers, :messenger_user_email, :string
  end
end
