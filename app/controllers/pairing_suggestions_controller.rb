class PairingSuggestionsController < ApplicationController
  before_action :verify_authorization_header unless Rails.env.test?
  skip_before_action :verify_authenticity_token

  def show
    @pair = PairingSuggest.new(params[:id]).get_pair_suggestions

    render json: @pair, status: :ok
  end
end