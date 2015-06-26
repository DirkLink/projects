class TransitController < ApplicationController

  def index
    @loc  = [params[:lat].to_f,params[:long].to_f]
    # @loc = [38.9059620,-77.0423670]
    @nearest_metro = TrainStation.nearest_stations @loc
    @nearest_bus = BusStation.nearest_stations @loc
    @nearest_bike = BikeStation.nearest_stations @loc
  end
end
