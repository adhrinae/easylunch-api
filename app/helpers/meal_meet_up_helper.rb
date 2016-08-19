# Helper Module for MealMeetUp Controller
module MealMeetUpHelper
  def response_json_show(meetup)
    basic_data = response_json_update(meetup)
    members_info = meetup.meal_meet_up_tasks.map do |task|
      log = task.meal_log
      { member_uid: log.user.service_uid,
        menu: log.menu_name,
        price: log.price,
        status: task.status.value }
    end
    basic_data[:data].merge(members_count: members_info.count,
                            members: members_info)
  end

  # meetup#create 완료 후 반환할 정보
  def response_json_create(meetup)
    { data:
      { messenger: meetup.messenger.value,
        admin_uid: meetup.admin.service_uid,
        messenger_room_id: meetup.messenger_room_id } }
  end

  # meetup#update 완료 후 반환할 정보
  def response_json_update(meetup)
    { data:
      { messenger: meetup.messenger.value,
        admin_uid: meetup.admin.service_uid,
        messenger_room_id: meetup.messenger_room_id,
        total_price: meetup.total_price,
        status: meetup.status.value,
        pay_type: meetup.pay_type } }
  end
end
