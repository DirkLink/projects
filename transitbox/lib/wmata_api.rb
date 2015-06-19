require 'httparty'
require 'json'
require 'pry'

class WMataAPI
  Token = File.read "./token.txt"

  include HTTParty
  base_uri 'https://api.wmata.com'

  def initialize loc
    #@headers = { "Authorization" => "token #{Token}"}
    @loc = loc
  end

  def distance_list
    station_array = []
    stations = MetroStation.all
    stations.each do |s|
      station_array.push([s.code,s.name,s.distance(@loc)])
    end
    station_array.sort_by! {|a| a[2]}
    station_array[0..2]
  end

  def nearest_stations
    trains = []
    stations = distance_list
    stations.each do |s|
      code = s[0]
      distance = s[2]
      station = MetroStation.find_by_code(code)
      trains = trains.push(Hash[:address,station.address,:name, station.name,:distance, distance, :train, trains_at_station(code)])
    end
    # trains = Hash[:station, trains]
    trains = Hash[:station,trains]
    trains
  end


  def trains_at_station code
    # station = MetroStation.find_by_code(code)
    s = WMataAPI.get("https://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{code}", query: { api_key: "#{Token}" })
    trains = s["Trains"].map {|s| s.values_at("Line","Min","LocationName","DestinationName")}
    trains = trains.map {|train| Hash[:Line,train[0],:Min,train[1],:destination,train[3]]}
  end

  def self.update_metro_stations
    MetroStation.delete_all
    s = WMataAPI.get("/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
    station_array = s["Stations"].map {|s| s.values_at("Name","Lat","Lon","Code","Address")}
    station_array.each do |station|
      MetroStation.create! name: station[0], lat: station[1], long: station[2], code: station[3], address: station[4]["Street"]
    end
  end

  def self.update_bus_stations
    s = WMataAPI.get("/Bus.svc/json/jStops", query: { api_key: "#{Token}" })
    station_array = s["Stops"].map {|s| s.values_at("Name","StopID","Lat","Lon")}
    station_array.each do |station|
      BusStation.create! address: station[0], stop_id: station[1], lat: station[2],  long: station[3]
    end
  end

  def bus_stops
    s = WMataAPI.get("/Bus.svc/json/jStops", query: { api_key: "#{Token}" })

  end

   def distance_list_bus
    station_array = []
    stations = BusStation.all
    stations.each do |s|
      station_array.push([s.stop_id,s.address,s.distance(@loc)])
    end
    station_array.compact!
    station_array.sort_by! {|a| a[2]}
    station_array[0..2]
  end

  def nearest_stops
    buses = []
    buses = distance_list_bus
    buses.each do |s|
      code = s[0].to_i
      distance = s[2]
      stop = BusStation.find_by_stop_id(code)
      # binding.pry
      if buses_at_stop(code)
        buses = buses.push(Hash[:address, stop.address, :distance, distance, :bus, buses_at_stop(code)])
      end
    end
    buses
  end

  def buses_at_stop code
    s = WMataAPI.get("https://api.wmata.com/NextBusService.svc/json/jPredictions", query: { StopID: "#{code}", api_key: "#{Token}" })
      if s["Predictions"]
        buses = s["Predictions"].map {|h| h.values_at("Minutes","RouteID","DirectionText")}
        buses = buses.map {|bus| Hash[:Minutes,bus[0],:RouteID,bus[1],:directionText,bus[2]]}
        buses
      end
  # rescue => e
  #   binding.pry
  end

end

# require 'pry'
# t = WMataAPI.new [0,0]
# binding.pry


