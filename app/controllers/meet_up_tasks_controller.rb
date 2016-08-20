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
      render_already_enrolled_member
    end
  end

  def update
    if User.enrolled_user?(task_params[:member_id], @meetup)
      if !check_user_data.nil?
        render_error_400(check_user_data)
      else
        task = User.update_task_status(@meetup, task_params)
        render_200(update_response(@meetup, task))
      end
    else
      render_already_enrolled_member
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
      meetup_pay_type = @meetup.pay_type
      if @meetup.total_price.nil?
        render_error_400('set up total_price first')
      elsif meetup_pay_type == 'n' && !task_params[:price].nil?
        render_error_400('the price was already fixed')
      elsif @meetup.price_overcharged?(task_params)
        render_error_400('price overcharged')
      end
    end

    def check_update_info
      if @meetup.total_price.to_s.empty?
        render_error_400("set meetup's total_price first")
      elsif !%w(unpaid paid).include?(task_params[:status].to_s)
        render json: { error: 'invalid status' }, status: 400
      end
    end

    def check_user_data
      user = User.find_by(service_uid: task_params[:member_id])
      if !user.price_entered?(@meetup)
        'no price entered'
      elsif !user.ready_to_update?(@meetup, task_params[:status])
        'cannot change to same status'
      end
    end

    def render_already_enrolled_member
      render json:
             { error: 'this member_id is not enrolled in the current meetup' },
             status: 401
    end

    def params_authorizable?
      [task_params[:messenger], task_params[:member_id],
       task_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end
end
