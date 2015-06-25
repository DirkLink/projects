class Bus
  attr_reader :Minutes, :RouteID, :directionText

  def initialize api_data
    @RouteID       = api_data.fetch "RouteID"
    @directionText = api_data.fetch "DirectionText"
    @Minutes       = api_data.fetch "Minutes"
  end
end