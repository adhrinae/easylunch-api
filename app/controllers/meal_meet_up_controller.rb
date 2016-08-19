# meal_meet_ups api controller
class MealMeetUpController < ApplicationController
  before_action :authorize_params, only: [:show, :create, :update]
  before_action :check_meetup_create, only: [:create]
  before_action :check_meetup_update, only: [:show, :update]
  before_action :find_meetup, only: [:show, :create, :update]

  def show
    render_200(response_json_update(@meetup))
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

    def check_meetup_create
      meetup = find_meetup
      return true if meetup.nil?
      render json: { error: 'meetup already created' }, status: 400
    end

    # 해당하는 meetup이 없거나 admin_uid가 불일치하면 에러
    def check_meetup_update
      meetup = find_meetup
      if meetup.nil?
        render json: { error: 'cannot find meetup' }, status: 400
      elsif meetup.admin.service_uid != meetup_params[:admin_uid].to_s
        render json: { error: 'invalid admin_uid' }, status: 401
      end
    end

    def params_authorizable?
      [meetup_params[:messenger], meetup_params[:admin_uid],
       meetup_params[:messenger_room_id]].all? { |e| !e.to_s.empty? }
    end

    # meetup#create 완료 후 반환할 정보
    def response_json_create(meetup)
      { data:
        { messenger: meetup.messenger.value,
          admin_uid: meetup.admin.service_uid,
          messenger_room_id: meetup.messenger_room_id } }
    end

    # meetup#update 완료 후 반환할 정보
    def response_json_update(meetup)
      { data:
        { messenger: meetup.messenger.value,
          admin_uid: meetup.admin.service_uid,
          messenger_room_id: meetup.messenger_room_id,
          total_price: meetup.total_price,
          status: meetup.status.value } }
    end
end
