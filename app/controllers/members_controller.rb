# Members Controller
class MembersController < ApplicationController
  before_action :find_meetup, only: [:add_members]
  def add_member
    entry_members = member_params[:member_ids]
    if params_authorizable? && params_valid?
      entry_members.each { |member| add_flow(member) }
      render_200(add_user_reponse)
    elsif !params_valid?
      render_error_400
    else
      render_error_401
    end
  end

  private

    def member_params
      params.require(:data).permit(:email, :messenger,
                                   :messenger_room_id, :member_ids)
    end

    def find_meetup
      @meetup = MealMeetUp.find_by(messenger_room_id =>
                                   member_params[:messenger_room_id])
    end

    def add_flow(member)
      user = User.create(service_uid: member)
      user_log = UserLog.create(user_id: user.id)
      UserMessenger.create(user_id: user.id,
                           messenger_code: load_messenger_code)
      MealMeetUpTask.create(meal_log_id: user_log.id,
                            meal_meet_up_id: @meetup.id,
                            task_status: init_task_code)
    end

    def add_user_reponse
      { data:
        { email: @meetup.admin_id.service_uid,
          messenger: @meetup.admin.user_messenger.messenger,
          messenger_room_id: @meetup.messenger_room_id,
          member_ids: member_params[:member_ids] } }
    end

    def load_messenger_code
      CodeTable.find_messenger(member_params[:messenger]).id
    end

    def init_task_code
      CodeTable.find_task('unpaid').id
    end

    def params_valid?
      !meetup_params[:messenger_room_id].to_s.empty? &&
        !meetup_params[:member_ids].empty?
    end

    def params_authorizable?
      !email_invalid?(member_params[:email]) &&
        !member_params[:messenger].to_s.empty?
    end
end
