# Members Controller
class MembersController < ApplicationController
  include MembersHelper
  before_action :check_params, only: [:add_member]
  before_action :check_meetup, only: [:add_member]
  def add_member
    @meetup = find_meetup
    entry_members = member_params[:member_ids]
    entry_members.each { |member| init_member(member, @meetup) }
    # 맴버가 추가된 MeetUp은 상태를 변경해준다.
    @meetup.update(meetup_status: CodeTable.find_status('paying').id)
    render_200(add_user_response(@meetup))
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

    # TODO: 유저 등록 관련 작업 전반에 모두 들어갈 필요가 있으니 user.rb에 정의해야할듯
    def init_member(member, meetup)
      user = User.create(service_uid: member)
      user_log = MealLog.create(user_id: user.id)
      UserMessenger.create(user_id: user.id,
                           messenger_code: load_messenger_code)
      MealMeetUpTask.create(meal_log_id: user_log.id,
                            meal_meet_up_id: meetup.id,
                            task_status: load_task_code)
    end

    def add_user_response(meetup)
      { data:
        { email: meetup.admin.service_uid,
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
