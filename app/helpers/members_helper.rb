# Members Helper
module MembersHelper
  def check_meetup
    meetup = find_meetup
    render_error_400 unless meetup.status.value == 'created'
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
    !member_params[:messenger_room_id].to_s.empty? &&
      !member_params[:member_ids].to_s.empty?
  end

  def params_authorizable?
    !email_invalid?(member_params[:email]) &&
      !member_params[:messenger].to_s.empty?
  end
end
