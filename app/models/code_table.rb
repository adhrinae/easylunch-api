# Code Table
class CodeTable < ActiveRecord::Base
  # 테이블 정의
  # code_type: "messenger", code: 0, value: "slack"
  # code_type: "messenger", code: 1, value: "telegram"
  # code_type: "messenger", code: 2, value: "kakotalk"
  # code_type: "meetup_status", code: 0, value: "created"
  # code_type: "meetup_status", code: 1, value: "paying"
  # code_type: "meetup_status", code: 2, value: "complete"
  # code_type: "task_status", code: 0, value: "unpaid"
  # code_type: "task_status", code: 1, value: "paid"

  # 제대로 작동하지 않는듯 하고 어차피 코드테이블은 참조만 하니까 관계 설정을 안해도 될듯?
  # has_many :meal_meet_ups, foreign_key: 'messenger_code'
  # has_many :meal_meet_ups, foreign_key: 'meetup_status'
  # has_many :meal_meet_up_tasks, foreign_key: 'task_status'
  # has_many :user_messengers, foreign_key: 'messenger_code'

  scope :find_messenger, lambda { |messenger|
    find_by(code_type: 'messenger', value: messenger)
  }
  scope :find_meetup_status, lambda { |status|
    find_by(code_type: 'meetup_status', value: status)
  }
  scope :find_task_status, lambda { |task|
    find_by(code_type: 'task_status', value: task)
  }
end
