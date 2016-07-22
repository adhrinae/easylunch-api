# User Messenger model
class UserMessenger < ActiveRecord::Base
  belongs_to :user
  belongs_to :messenger, class_name: 'CodeTable', foreign_key: 'messenger_code'
end
