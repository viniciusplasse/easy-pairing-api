
class PairingSuggest
  def initialize(team_id)
    @team = Team.find(team_id)
    @members = @team.members
  end
  
  def get_pair_suggestions
    members_analysed = []

    @members.each do |member|
      members_analysed << member

      @members.each do |peer|
        next if member.id == peer.id || members_analysed.include?(peer)

        times_together = member.get_pairing_occurrences_with(peer)
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

    @pair
  end
end