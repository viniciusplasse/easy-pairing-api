class MembersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def destroy
    member_id = params[:id]

    begin
      Member.destroy(member_id)
    rescue ActiveRecord::RecordNotFound
      return head :not_found
    rescue StandardError
      return head :internal_sever_error
    end

    head :ok
  end
end
