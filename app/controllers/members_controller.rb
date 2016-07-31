# Members Controller
class MembersController < ApplicationController
  include MembersHelper
  before_action :check_params, only: [:add_member]
  before_action :check_meetup, only: [:add_member]
  def add_member
    @meetup = find_meetup
    entry_members = member_params[:member_ids]
    entry_members.each do |member|
      task_unpaid = CodeTable.find_task('unpaid').id
      User.init_member(member, @meetup,
                       load_messenger_code(member_params), task_unpaid)
    end
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
