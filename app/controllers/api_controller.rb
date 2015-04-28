class ApiController < ActionController::Base
  def players
    render json: players_for_api
  end

  def results
    render json: results_for_api
  end

  private
    def players_for_api
      last_points = nil

      Player.in_elo_order.map.with_index { |player, index|
        points = player.elo_rating
        position = points == last_points ? '=' : (index + 1)
        last_points = points

        {
          id: player.id,
          name: player.name,
          points: points,
          position: position
        }
      }
    end

    def results_for_api
      Result.latest_first.includes(:loser, :winner).page(1).per(20).map { |result|
        {
          id: result.id,
          text: "#{result.winner.name} beat #{result.loser.name}"
        }
      }
    end
end
