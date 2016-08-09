# MealMeetUpTask Controller
class MeetUpTasksController < ApplicationController
  before_action :check_params, only: [:menu]
  before_action :before_update_check, only: [:update]
  def menu
  end

  def update
  end

  private
    def task_params
      params.require(:data).permit(:email, :messenger, :messenger_room_id,
                                   :member_id, :price, :menu, :status)
    end

    def params_valid?
      [task_params[:price], task_params[:menu]].all? { |e| !e.to_s.empty? }
    end

    def params_authorizable?
      !email_invalid?(task_params[:email]) &&
        [task_params[:messenger], task_params[:member_id],
         task_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end

    def before_update_check
      params_authorizable? && !task_params[:status].to_s.empty?
    end
end
