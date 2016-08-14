# MealMeetUpTask Controller
class MeetUpTasksController < ApplicationController
  before_action :authorize_params, only: [:menu, :update]
  before_action :check_menu_info, only: [:menu]
  before_action :before_update_check, only: [:update]
  def menu
    @meetup = find_meetup
    if User.enrolled_user?(task_params[:member_id], @meetup)
      @meal_log = User.update_menu(@meetup, task_params)
      render_201(menu_response(@meetup, @meal_log))
    else
      render json:
             { error: 'this member_id is not enrolled in the current meetup' },
             status: 401
    end
  end

  def update
  end

  private
    def task_params
      params.require(:data).permit(:messenger, :messenger_room_id,
                                   :member_id, :price, :menu, :status)
    end

    def find_meetup
      @meetup = MealMeetUp.find_by(messenger_room_id:
                                   task_params[:messenger_room_id])
    end

    def menu_response(meetup, meal_log)
      { data:
        { messenger: meetup.messenger.value,
          messenger_room_id: meetup.messenger_room_id,
          member_id: meal_log.user.service_uid,
          price: meal_log.price,
          menu: meal_log.menu_name,
          status: meal_log.meal_meet_up_task.status.value } }
    end

    def check_menu_info
      if task_params[:menu].to_s.empty? || task_params[:price].to_s.empty?
        render json: { error: 'menu informations needed' }, status: 400
      else
        true
      end
    end

    def params_authorizable?
      [task_params[:messenger], task_params[:member_id],
       task_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end

    # 상태 업데이트를 위해 상태가 비어있는지 확인
    def before_update_check
      params_authorizable? && !task_params[:status].to_s.empty?
    end
end
