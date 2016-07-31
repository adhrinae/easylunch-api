# Members Controller
class MembersController < ApplicationController
  include MembersHelper
  before_action :check_params, only: [:add_member]
  before_action :check_meetup, only: [:add_member]
  before_action :find_meetup, only: [:add_member]
  def add_member
    entry_members = member_params[:member_ids]
    entry_members.each do |member|
      task_unpaid = CodeTable.find_task('unpaid').id
      unless get_members_list(@meetup).include?(member.to_s)
        User.init_member(member, @meetup,
                         load_messenger_code(member_params), task_unpaid)
      end
    end
    render_200(add_user_response(find_meetup)) # 새로 MeetUp을 로딩해야 올바른 목록이 나온다.
  end

  private

    def member_params
      params.require(:data).permit(:email, :messenger,
                                   :messenger_room_id, member_ids: [])
    end

    def find_meetup
      @meetup = MealMeetUp.find_by(messenger_room_id:
                                   member_params[:messenger_room_id])
    end

    def add_user_response(meetup)
      { data:
        { email: meetup.admin.find_messenger_email(meetup.messenger_code),
          messenger: meetup.messenger.value,
          messenger_room_id: meetup.messenger_room_id,
          member_ids: get_members_list(meetup) } }
    end

    # MeetUp에 속한 Task를 가지고 있는 멤버들의 명단을 가져온다.
    def get_members_list(meetup)
      tasks = meetup.meal_meet_up_tasks
      tasks.map { |task| task.meal_log.user.service_uid }
    end
end
