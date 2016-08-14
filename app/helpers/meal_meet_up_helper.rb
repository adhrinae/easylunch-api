# Helper Module for MealMeetUp Controller
module MealMeetUpHelper
  def load_status_code(status)
    CodeTable.find_status(status).id
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
end
