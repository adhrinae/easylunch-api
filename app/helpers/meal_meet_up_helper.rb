# Helper Module for MealMeetUp Controller
module MealMeetUpHelper
  def load_status
    meetup_params[:status].nil? ? 'created' : meetup_params[:status]
  end

  def load_status_code
    CodeTable.find_status(load_status).id
  end

  def load_user
    params = meetup_params
    if load_status == 'created'
      @user = User.create(service_uid: params[:messenger_user_id])
      UserMessenger.create(user_id: @user.id,
                           messenger_user_id: params[:messenger_user_id],
                           messenger_code: load_messenger_code)
    else
      @user = User.find_by(service_uid: params[:messenger_user_id])
    end
    @user
  end

  def find_meetup
    @meetup = MealMeetUp.find_by(messenger_room_id:
                                 @params[:messenger_room_id])
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
