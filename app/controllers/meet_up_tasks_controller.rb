# MealMeetUpTask Controller
class MeetUpTasksController < ApplicationController
  before_action :check_params, only: [:menu]
  before_action :before_update_check, only: [:update]
  def menu
    User.update_menu(@meetup, task_params)
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
