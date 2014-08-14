class Ladder
  class Ranking
    def self.to_proc
      ->(player) { new(player) }
    end

    def initialize(player)
      @player = player
    end

    def player_name
      player.name
    end

    def position
      player.position
    end

    def score
      player.elo_rating
    end

    def score_history
      recorded_values = player.results.in_order.last(50).map(&:previous_state).map{|state| state['elo_ratings'].fetch(player.id){ nil } }
      values = recorded_values + [player.elo_rating]
      values.map{|v| v ? v - score_central_value : 0 }
    end

    private
      attr_reader :player

      def score_central_value
        @score_central_value ||= EloRating.instance.initial_rating
      end
  end

  def self.current
    new
  end

  def rankings
    Player.in_elo_order.map(&Ranking)
  end

  def score_history_max
    [min_elo_value, max_elo_value].map(&:abs).max
  end

  def score_history_min
    -score_history_max
  end

  private
    def min_elo_value
      min = previous_scores.min
      min ? min - sparkline_central_value : sparkline_central_value
    end

    def max_elo_value
      max = previous_scores.max
      max ? max - sparkline_central_value : sparkline_central_value
    end

    def previous_scores
      @previous_scores ||= Result.all.flat_map { |result|
        result.previous_state.fetch('elo_ratings', {}).values.compact
      }
    end

    def sparkline_central_value
      @sparkline_central_value ||= EloRating.instance.initial_rating
    end
end
