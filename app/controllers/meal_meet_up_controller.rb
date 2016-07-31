# meal_meet_ups api controller
class MealMeetUpController < ApplicationController
  include MealMeetUpHelper
  before_action :check_params, only: [:create, :update]
  before_action :init_meetup, only: [:create]
  before_action :find_meetup, only: [:update]

  def create
    @admin = User.init_member(meetup_params[:messenger_user_id], @meetup,
                              load_messenger_code(meetup_params),
                              CodeTable.find_task('unpaid').id)
    update_additional_info(@admin, @meetup)
    render_201(response_json(@meetup))
  end

  def update
    if params_authroizable? && params_valid?
      @meetup.update_attributes(@params)
      respond_to do |format|
        format.json { render json: response_json(@meetup), status: 200 }
      end
    elsif !params_valid?
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

    def init_meetup
      @meetup = MealMeetUp.init_meetup(meetup_params)
    end

    # 생성된 admin에 이메일 주소를 지정해주고, meetup의 admin을 지정해준다.
    def update_additional_info(admin, meetup)
      admin.add_email(load_messenger_code(meetup_params),
                      meetup_params[:email])
      meetup.update(admin_id: admin.id)
    end
    # def fetch_params
    #   @params = get_more_info(load_user, load_messenger_code,
    #                           load_status_code, meetup_params)
    # end

    # def get_more_info(user, messenger_code, status_code, params)
    #   additional_data = { admin_id: user.id,
    #                       messenger_code: messenger_code,
    #                       meetup_status: status_code }

    #   params.merge(additional_data).reject do |key|
    #     %w(email messenger status messenger_user_id).include?(key.to_s)
    #   end
    # end
    def response_json(meetup)
      { data:
        { email: meetup.admin.find_messenger_email(meetup.messenger_code),
          messenger: meetup.messenger.value,
          admin_uid: meetup.admin.service_uid,
          messenger_room_id: meetup.messenger_room_id } }
    end
  # def create_response(data)
  #   { data: response_json(data)[:data].select do |key|
  #     %w(email messenger messenger_room_id).include?(key.to_s)
  #   end }
  # end
end
