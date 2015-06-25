class Bike
  attr_reader :num_empty_docks, :num_bikes

 def initialize api_data
    @num_bikes       = api_data.fetch "nbBikes"
    @num_empty_docks = api_data.fetch "nbEmptyDocks"
  end
end