# Code Table
class CodeTable < ActiveRecord::Base
  # 테이블 정의
  # code_type: "messenger", code: 0, value: "slack"
  # code_type: "messenger", code: 1, value: "telegram"
  # code_type: "messenger", code: 2, value: "kakotalk"
  # code_type: "meetup_status", code: 0, value: "created"
  # code_type: "meetup_status", code: 1, value: "paying_avg"
  # code_type: "meetup_status", code: 2, value: "paying_sep"
  # code_type: "meetup_status", code: 3, value: "complete"
  # code_type: "task_status", code: 0, value: "unpaid"
  # code_type: "task_status", code: 1, value: "paid"

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
