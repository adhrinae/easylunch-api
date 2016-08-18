# MealMeetUpTask Controller
class MeetUpTasksController < ApplicationController
  before_action :authorize_params, only: [:menu, :update]
  before_action :find_meetup, only: [:menu, :update]
  before_action :check_menu_info, only: [:menu]
  before_action :check_update_info, only: [:update]
  def menu
    if User.enrolled_user?(task_params[:member_id], @meetup)
      meal_log = User.update_menu(@meetup, task_params)
      render_201(menu_response(@meetup, meal_log))
    else
      render json:
             { error: 'this member_id is not enrolled in the current meetup' },
             status: 401
    end
  end

  def update
    if User.enrolled_user?(task_params[:member_id], @meetup)
      task = User.update_task_status(@meetup, task_params)
      render_200(update_response(@meetup, task))
    else
      render json:
             { error: 'this member_id is not enrolled in the current meetup' },
             status: 401
    end
  end

  private
    def task_params
      params.require(:data).permit(:messenger, :messenger_room_id,
                                   :member_id, :price, :menu, :status)
    end

    def find_meetup
      @meetup = MealMeetUp.find_by(messenger_room_id:
                                   params[:data][:messenger_room_id])
      render_error_400('cannot find meetup') if @meetup.nil?
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

    def update_response(meetup, task)
      { data:
        { messenger: meetup.messenger.value,
          messenger_room_id: meetup.messenger_room_id,
          member_id: task.meal_log.user.service_uid,
          status: task.status.value } }
    end

    def check_menu_info
      if @meetup.total_price.nil?
        render_error_400('set up total_price first')
      elsif @meetup.status.value == 'paying_avg'
        render json: { error: 'the price was already fixed' }, status: 400
      elsif task_params[:price].to_s.empty?
        render_error_400('price value needed')
      end
    end

    # 상태 업데이트를 위해 상태가 비어있는지 확인
    def check_update_info
      unless %w(unpaid paid).include?(task_params[:status].to_s)
        render json: { error: 'invalid status' }, status: 400
      end
    end

    def params_authorizable?
      [task_params[:messenger], task_params[:member_id],
       task_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end
end
