require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  describe "#create" do
    describe "returns bad request" do
      it "when name is missing" do
        team = {
          members: ['John', 'Mary', 'Joseph', 'Claudia']
        }
        
        post :create, params: team 
  
        expect(response).to have_http_status(:bad_request)
      end
  
      it "when member list is missing" do
        team = {
          name: 'Example team'
        }
  
        post :create, params: team 
  
        expect(response).to have_http_status(:bad_request)
      end
  
      it "when members length is less than 3" do
        team = {
          name: 'Example team',
          members: ['John', 'Mary']
        }
  
        post :create, params: team 
  
        expect(response).to have_http_status(:bad_request)
      end
    end

    it "returns created if everything is ok" do
      team = {
        name: 'Example Team',
        members: ['John', 'Mary', 'Joseph', 'Claudia']
      }

      post :create, params: team 

      expect(response).to have_http_status(:created)
    end
  end

end
