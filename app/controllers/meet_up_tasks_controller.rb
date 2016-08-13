# MealMeetUpTask Controller
class MeetUpTasksController < ApplicationController
  before_action :check_params, only: [:menu]
  before_action :before_update_check, only: [:update]
  def menu
    @meetup = find_meetup
    @meal_log = User.update_menu(@meetup, task_params)
    render_201(menu_response(@meetup, @meal_log))
  end

  def update
  end

  private
    def task_params
      params.require(:data).permit(:email, :messenger, :messenger_room_id,
                                   :member_id, :price, :menu, :status)
    end

    def find_meetup
      @meetup = MealMeetUp.find_by(messenger_room_id:
                                   task_params[:messenger_room_id])
    end

    # 기존에 결과를 리턴할 때는 일일이 DB에서 해당하는 값을 직접 검색하여 가져왔는데, 굳이 그럴 필요가 없어보인다.
    def menu_response(meetup, meal_log)
      { data:
        { email: meal_log.user.find_messenger_email(meetup.messenger_code),
          messenger: meetup.messenger.value,
          messenger_room_id: meetup.messenger_room_id,
          member_id: meal_log.user.service_uid,
          price: meal_log.price,
          menu: meal_log.menu_name,
          status: meal_log.meal_meet_up_task.status.value } }
    end

    def params_valid?
      [task_params[:price], task_params[:menu]].all? { |e| !e.to_s.empty? }
    end

    def params_authorizable?
      !email_invalid?(task_params[:email]) &&
        [task_params[:messenger], task_params[:member_id],
         task_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end

    # 상태 업데이트를 위해 상태가 비어있는지 확인
    def before_update_check
      params_authorizable? && !task_params[:status].to_s.empty?
    end
end
