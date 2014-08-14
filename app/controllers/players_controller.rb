class PlayersController < ApplicationController
  before_action :authenticate, only: :create
  respond_to :html

  def create
    @player = Player.create(create_params.merge(elo_rating: EloRating.instance.initial_rating))
    EloRating.instance.recalculate_positions
    respond_with @player, location: root_url
  end

  private

  def create_params
    params.require(:player).permit(:name)
  end
end
