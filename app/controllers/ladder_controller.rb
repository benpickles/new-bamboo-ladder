class LadderController < ApplicationController
  def show
    @ladder = Ladder.current
  end
end
