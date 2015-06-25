class TransitController < ApplicationController

  def index
    # @loc  = [params[:latitude].to_f,params[:longitude].to_f]
    @loc = [38.9059620,-77.0423670]
    # t = TrainApi.new loc
    # b = BikeApi.new loc
    # bs = BusApi.new loc
    @nearest_metro = TrainStation.nearest_stations @loc
    @nearest_bus = BusStation.nearest_stations @loc
    @nearest_bike = BikeStation.nearest_stations @loc
  end
end
