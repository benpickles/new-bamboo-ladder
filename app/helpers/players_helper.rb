module PlayersHelper
  def players_as_options
    ['---'] + Player.alphabetical.map{|e| [e.name, e.id] }
  end

  def sparkline_max
    [min_elo_value, max_elo_value].map(&:abs).max
  end

  def sparkline_min
    -sparkline_max
  end

  def sparkline_central_value
    @sparkline_central_value ||= EloRating.instance.initial_rating
  end

  private

  def previous_scores
    @previous_scores ||= Result.all.flat_map { |result|
      result.previous_state.fetch('elo_ratings', {}).values.compact
    }
  end

  def min_elo_value
    min = previous_scores.min
    min ? min - sparkline_central_value : sparkline_central_value
  end

  def max_elo_value
    max = previous_scores.max
    max ? max - sparkline_central_value : sparkline_central_value
  end
end
