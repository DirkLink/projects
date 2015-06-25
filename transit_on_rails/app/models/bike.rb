class Bike
  attr_reader :nbEmptyDocks, :nbBikes

 def initialize api_data
    @nbBikes = api_data.fetch "nbBikes"
    @nbEmptyDocks = api_data.fetch "nbEmptyDocks"
  end
end