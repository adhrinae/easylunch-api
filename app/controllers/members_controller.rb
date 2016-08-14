# Members Controller
class MembersController < ApplicationController
  before_action :authorize_params, only: [:add_member, :delete_member]
  before_action :check_add_member, only: [:add_member]
  before_action :check_delete_member, only: [:delete_member]
  before_action :find_meetup, only: [:add_member, :delete_member]
  def add_member
    entry_member = member_params[:member_id].to_s
    task_unpaid = load_task_code('unpaid')
    unless get_members_list(@meetup).include?(entry_member)
      User.init_member(entry_member, @meetup,
                       load_messenger_code(member_params), task_unpaid)
    end
    render_200(member_response(find_meetup)) # 새로 MeetUp을 로딩해야 올바른 목록이 나온다.
  end

  def delete_member
    target_member = member_params[:member_id].to_s
    User.delete_member(target_member, @meetup)
    render_200(member_response(find_meetup))
  end

  private

    def member_params
      params.require(:data).permit(:messenger,
                                   :messenger_room_id, :member_id)
    end

    def check_add_member
      meetup = find_meetup
      if meetup.nil?
        render json: { error: 'cannot find meetup' }, status: 400
      elsif meetup.status.value != 'created'
        render json: { error: 'cannot add members to this meetup' }, status: 400
      elsif member_params[:member_id].to_s.empty?
        render json: { error: 'there is no member to enroll' }, status: 400
      end
    end

    def check_delete_member
      meetup = find_meetup
      member_id = member_params[:member_id].to_s
      if meetup.nil?
        render json: { error: 'cannot find meetup' }, status: 400
      elsif meetup.admin.service_uid == member_id
        render json: { error: 'cannot delete admin member' }, status: 400
      elsif !get_members_list(meetup).include?(member_id)
        render json: { error: 'cannot find the member_id in this meetup' },
               status: 400
      end
    end

    def params_authorizable?
      [member_params[:messenger], member_params[:messenger_room_id]].all? do |e|
        !e.to_s.empty?
      end
    end

    def member_response(meetup)
      { data:
        { messenger: meetup.messenger.value,
          messenger_room_id: meetup.messenger_room_id,
          member_ids: get_members_list(meetup) } }
    end

    # MeetUp에 속한 Task를 가지고 있는 멤버들의 명단을 가져온다.
    def get_members_list(meetup)
      tasks = meetup.meal_meet_up_tasks
      tasks.map { |task| task.meal_log.user.service_uid }
    end
end
