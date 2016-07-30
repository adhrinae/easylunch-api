# Members Controller
class MembersController < ApplicationController
  def add_member
    @meetup = find_meetup
    entry_members = member_params[:member_ids]
    if params_authorizable? && params_valid?
      entry_members.each { |member| add_flow(member, @meetup) }
      render_200(add_user_response(@meetup))
    elsif !params_valid?
      render_error_400
    else
      render_error_401
    end
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

    def add_flow(member, meetup)
      user = User.create(service_uid: member)
      user_log = MealLog.create(user_id: user.id)
      UserMessenger.create(user_id: user.id,
                           messenger_code: load_messenger_code)
      MealMeetUpTask.create(meal_log_id: user_log.id,
                            meal_meet_up_id: meetup.id,
                            task_status: init_task_code)
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

    def load_messenger_code
      CodeTable.find_messenger(member_params[:messenger]).id
    end

    # Task가 만들어질땐 'unpaid'상태로 등록.
    def init_task_code
      CodeTable.find_task('unpaid').id
    end

    def params_valid?
      !member_params[:messenger_room_id].to_s.empty? &&
        !member_params[:member_ids].empty?
    end

    def params_authorizable?
      !email_invalid?(member_params[:email]) &&
        !member_params[:messenger].to_s.empty?
    end
end
