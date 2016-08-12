# Helper Module for MealMeetUp Controller
module MealMeetUpHelper
  def load_status
    meetup_params[:status].nil? ? 'created' : meetup_params[:status]
  end

  def load_status_code(status)
    CodeTable.find_status(status).id
  end

  def find_meetup
    @meetup = MealMeetUp.find_by(messenger_room_id:
                                 meetup_params[:messenger_room_id])
  end

  def check_meetup_create
    meetup = find_meetup
    return true if meetup.nil?
    respond_to do |format|
      format.json do
        render json: { error: 'meetup already created' }, status: 400
      end
    end
  end

  # 해당하는 meetup이 없으면 에러
  def check_meetup_update
    meetup = find_meetup
    if meetup.nil?
      render_error_400
    elsif meetup.admin.service_uid != meetup_params[:messenger_user_id].to_s
      render_error_401
    else
      return true
    end
  end

  def check_params
    if !params_valid?
      render_error_400
    elsif !params_authorizable?
      render_error_401
    else
      return true
    end
  end

  def params_valid?
    !meetup_params[:messenger].empty? &&
      !meetup_params[:messenger_room_id].to_s.empty?
  end

  def params_authorizable?
    # messenger_user_id가 optional이지만, 지금은 슬랙을 중심으로 개발중이고 이후에 가능하면 수정
    !email_invalid?(meetup_params[:email]) &&
      !meetup_params[:messenger_user_id].to_s.empty?
  end
end
