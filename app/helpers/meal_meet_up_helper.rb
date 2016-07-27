# Helper Module for MealMeetUp Controller
module MealMeetUpHelper
  def load_status
    meetup_params[:status].nil? ? 'created' : meetup_params[:status]
  end

  def load_status_code
    CodeTable.find_status(load_status).id
  end

  def load_messenger_code
    CodeTable.find_messenger(meetup_params[:messenger]).id
  end

  def load_user
    params = meetup_params
    if load_status == 'created'
      @user = User.create(email: params[:email])
      UserMessenger.create(user_id: @user.id,
                           messenger_user_id: params[:messenger_user_id],
                           messenger_code: load_messenger_code)
    else
      @user = User.find_by(email: params[:email])
    end
    @user
  end

  def find_meetup
    @meetup = MealMeetUp.find_by(messenger_room_id:
                                 @params[:messenger_room_id])
  end

  def params_valid?
    !meetup_params[:messenger].empty? &&
      !meetup_params[:messenger_room_id].to_s.empty?
  end

  def params_authroizable?
    # messenger_user_id가 optional이지만, 지금은 슬랙을 중심으로 개발중이고 이후에 가능하면 수정
    !email_invalid?(meetup_params[:email]) &&
      !meetup_params[:messenger_user_id].to_s.empty?
  end
end
