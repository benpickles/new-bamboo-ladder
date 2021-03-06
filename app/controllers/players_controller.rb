class PlayersController < ApplicationController
  before_action :authenticate, only: :create
  respond_to :html

  def index
    @players = Player.in_elo_order
  end

  def create
    @player = Player.create(create_params.merge(elo_rating: EloRating.instance.initial_rating))
    respond_with @player, location: players_path
  end

  private

  def create_params
    params.require(:player).permit(:name)
  end
end
