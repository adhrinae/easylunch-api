# Members Controller
class MembersController < ApplicationController
  def add_members
  end

  private

    def member_params
      params.require(:data).permit(:email, :messenger,
                                   :messenger_room_id, :member_ids)
    end

    def find_meetup
      @meetup = MealMeetUp.find_by(messenger_room_id =>
                                   member_params[:messenger_room_id])
    end

    def params_valid?
      !meetup_params[:messenger_room_id].to_s.empty? &&
        !meetup_params[:member_ids].empty?
    end

    def params_authorizable?
      !email_invalid?(member_params[:email]) &&
        !member_params[:messenger].to_s.empty?
    end
end
