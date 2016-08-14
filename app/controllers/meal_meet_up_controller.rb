# meal_meet_ups api controller
class MealMeetUpController < ApplicationController
  include MealMeetUpHelper
  before_action :authorize_params, only: [:create, :update]
  before_action :check_meetup_create, only: [:create]
  before_action :check_meetup_update, only: [:update]
  before_action :find_meetup, only: [:create, :update]

  def create
    init_meetup
    @admin = User.init_member(meetup_params[:admin_uid], @meetup,
                              load_messenger_code(meetup_params),
                              CodeTable.find_task('unpaid').id)
    set_admin_to_meetup(@admin, @meetup)
    render_201(response_json_create(@meetup))
  end

  def update
    @meetup.update(total_price: meetup_params[:total_price],
                   meetup_status: load_status_code(meetup_params[:status]))
    render_200(response_json_update(@meetup))
  end

  private
    def meetup_params
      params.require(:data).permit(:messenger, :messenger_room_id,
                                   :admin_uid, :total_price, :status)
    end

    def init_meetup
      @meetup = MealMeetUp.init_meetup(meetup_params)
    end

    # 생성된 admin에 이메일 주소를 지정해주고, meetup의 admin을 지정해준다.
    def set_admin_to_meetup(admin, meetup)
      meetup.update(admin_id: admin.id)
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
