# meal_meet_ups api controller
class MealMeetUpController < ApplicationController
  before_action :authorize_params, only: [:create, :update]
  before_action :find_meetup, only: [:show, :create, :update]
  before_action :check_meetup_show, only: [:show]
  before_action :check_meetup_create, only: [:create]
  before_action :check_meetup_update, only: [:update]
  include MealMeetUpHelper

  def show
    render_200(response_json_show(@meetup))
  end

  def create
    init_meetup
    @admin = User.init_member(meetup_params[:admin_uid], @meetup,
                              load_messenger_code(meetup_params),
                              load_task_code('unpaid'))
    set_admin_to_meetup(@admin, @meetup)
    render_201(response_json_create(@meetup))
  end

  def update
    # TODO: status가 올바른 값이 아니면 걸러내기(코드가 꼬이지 않도록)
    if meetup_params[:total_price].to_i <= 0
      render json: { error: 'invalid total_price' }, status: 400
    else
      @meetup.update_status(meetup_params[:total_price],
                            meetup_params[:status],
                            meetup_params[:pay_type])
      render_200(response_json_update(@meetup))
    end
  end

  private
    def meetup_params
      params.require(:data).permit(:messenger, :messenger_room_id, :admin_uid,
                                   :total_price, :status, :pay_type)
    end

    def init_meetup
      @meetup = MealMeetUp.init_meetup(meetup_params)
    end

    # 생성된 meetup의 admin을 지정해준다.
    def set_admin_to_meetup(admin, meetup)
      meetup.update(admin_id: admin.id)
    end

    def check_meetup_show
      if @meetup.nil?
        render_error_400('cannot find meetup')
      elsif [meetup_params[:messenger],
             meetup_params[:messenger_room_id]].any? { |e| e.to_s.empty? }
        render json: { error: 'cannt verify meetup information' }, status: 401
      end
    end

    def check_meetup_create
      return true if @meetup.nil?
      render json: { error: 'meetup already created' }, status: 400
    end

    # 해당하는 meetup이 없거나 admin_uid가 불일치, pay_type이 올바르지 않으면 에러
    def check_meetup_update
      if @meetup.nil?
        render_error_400('cannot find meetup')
      elsif @meetup.admin.service_uid != meetup_params[:admin_uid].to_s
        render_error_400('invalid admin_uid')
      else
        validate_pay_type
      end
    end

    def validate_pay_type
      if @meetup.status.value == 'paying' ||
         meetup_params[:status] == 'paying'
        unless %w(n s).include?(meetup_params[:pay_type])
          render_error_400('invalid pay_type or pay_type needed')
        end
      end
    end

    def params_authorizable?
      [meetup_params[:messenger], meetup_params[:admin_uid],
       meetup_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end
end
