# User model
class User < ActiveRecord::Base
  has_many :meal_meet_ups, foreign_key: 'admin_id'
  has_many :meal_logs
  has_many :user_messengers
end
