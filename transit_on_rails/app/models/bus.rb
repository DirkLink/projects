class Bus
  attr_reader :minutes, :routeID, :directionText

  def initialize api_data
    @routeID       = api_data.fetch "RouteID"
    @directionText = api_data.fetch "DirectionText"
    @minutes       = api_data.fetch "Minutes"
  end
end