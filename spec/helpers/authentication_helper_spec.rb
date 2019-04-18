require 'rails_helper'

RSpec.describe AuthenticationHelper, type: :helper do
  before :all do
    @team = Team.create(name: 'Example',
                        password: '123',
                        password_confirmation: '123')
  end

  it "#encode returns a JSON Web Token" do
    expect(encode(team_id: @team.id)).to match(/^eyJhbGciOiJIUzI1NiJ9.*/)
  end

  it "#decode returns a team_id" do
    jwt = encode(team_id: @team.id)

    expect(decode(jwt)[:team_id]).to eq(@team.id)
  end

  after :all do
    @team.destroy
  end
end
