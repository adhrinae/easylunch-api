# meal_meet_ups api controller
class MealMeetUpController < ApplicationController
  before_action :fetch_params, only: [:create, :update]
  before_action :find_meetup, only: [:update]
  include MealMeetUpHelper

  def create
    if params_authroizable? && params_valid?
      @meetup_data = MealMeetUp.create(@params)
      respond_to do |format|
        format.json { render json: create_response(@meetup_data), status: 201 }
      end
    elsif !params_valid?(@params)
      render_error_400
    else
      render_error_401
    end
  end

  def update
    if params_authroizable? && params_valid?
      @meetup.update_attributes(@params)
      respond_to do |format|
        format.json { render json: response_json(@meetup), status: 200 }
      end
    elsif !params_valid?(@params)
      render_error_400
    else
      render_error_401
    end
  end

  private
    def meetup_params
      params.require(:data).permit(:email, :messenger, :messenger_room_id,
                                   :messenger_user_id, :total_price, :status)
    end

    def fetch_params
      @params = get_more_info(load_user, load_messenger_code,
                              load_status_code, meetup_params)
    end

    def get_more_info(user, messenger_code, status_code, params)
      additional_data = { admin_id: user.id,
                          messenger_code: messenger_code,
                          meetup_status: status_code }

      params.merge(additional_data).reject do |key|
        %w(email messenger status messenger_user_id).include?(key.to_s)
      end
    end

    def response_json(data)
      { data:
        { email: data.admin.email,
          messenger: data.messenger.value,
          messenger_room_id: data.messenger_room_id,
          total_price: data.total_price,
          status: data.status.value } }
    end

    def create_response(data)
      { data: response_json(data)[:data].select do |key|
        %w(email messenger messenger_room_id).include?(key.to_s)
      end }
    end
end
