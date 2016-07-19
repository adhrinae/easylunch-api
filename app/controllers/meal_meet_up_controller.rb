# meal_meet_ups api controller
class MealMeetUpController < ApplicationController
  def create
  end

  def update
  end

  private
    def meetup_params
      params.require(:data).permit(:email, :messenger, :messenger_room_id,
                                   :total_price, :status)
    end
end
