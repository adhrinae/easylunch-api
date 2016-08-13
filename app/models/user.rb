# User model
class User < ActiveRecord::Base
  has_many :meal_meet_ups, foreign_key: 'admin_id'
  has_many :meal_logs
  has_many :user_messengers

  # 새로운 맴버 등록시 필요한 일련의 과정들
  def self.init_member(member_uid, meetup, messenger_code, task_code)
    user = find_by(service_uid: member_uid)
    if user.nil?
      result = enroll_new_user(member_uid, meetup, messenger_code, task_code)
    elsif user && user.find_enrolled_meetup(meetup.id).empty?
      result = enroll_exist_user(user, meetup, task_code)
    end
    result # Admin 등록을 위해 user정보가 리턴되어야 함
  end

  # DB에 기록되어있지 않은 맴버를 새로 생성
  def self.enroll_new_user(member_uid, meetup, messenger_code, task_code)
    user = User.create(service_uid: member_uid)
    user_log = MealLog.create(user_id: user.id)
    UserMessenger.create(user_id: user.id, messenger_code: messenger_code)
    MealMeetUpTask.create(meal_log_id: user_log.id,
                          meal_meet_up_id: meetup.id,
                          task_status: task_code)
    user
  end

  # DB에 등록된 적 있는 맴버가 새로운 MeetUp에 등록되는 경우
  def self.enroll_exist_user(user, meetup, task_code)
    user_log = MealLog.create(user_id: user.id)
    MealMeetUpTask.create(meal_log_id: user_log.id,
                          meal_meet_up_id: meetup.id,
                          task_status: task_code)
    user
  end

  def self.update_menu(meetup, user_info = {})
    user = find_by(service_uid: user_info[:member_id])
    user_log = user.find_enrolled_meetup(meetup.id) # 해당 MeetUp에 속하는 MealLog
    user_log.update(menu_name: user_info[:menu], price: user_info[:price])
    user_log
  end

  # 해당 user의 MeetUp등록 여부를 찾기 위해 Log > Task 연결하여 검색
  def find_enrolled_meetup(meetup_id)
    meal_logs.joins(:meal_meet_up_task).find_by(meal_meet_up_tasks:
                                              { meal_meet_up_id: meetup_id })
  end

  # 해당 유저의 messenger별 email 주소 삽입
  def add_email(messenger_code, email)
    messenger = user_messengers.find_by(messenger_code: messenger_code)
    messenger.update(messenger_user_email: email)
  end

  # 해당 유저의 messenger_code에 해당하는 email 주소 검색
  def find_messenger_email(messenger_code)
    messenger = user_messengers.find_by(messenger_code: messenger_code)
    messenger.messenger_user_email
  end
end
