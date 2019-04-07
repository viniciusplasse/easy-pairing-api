class PairingSuggestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    members = Team.find(params[:id]).members
    members_analysed = []

    members.each do |member|
      members_analysed << member

      members.each do |peer|
        next if member.id == peer.id || members_analysed.include?(peer)

        times_together = member.pairing_records.select { |record| record.members.include?(peer) }.length
        @lowest = times_together if @lowest.nil?

        if times_together < @lowest
          @lowest = times_together
          @pair = {
            members: [
              { id: member.id, name: member.name },
              { id: peer.id, name: peer.name }
            ]
          }
        end
      end
    end

    render json: @pair, status: :ok
  end
end