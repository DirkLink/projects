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
    trains = Hash.new
    stations = distance_list
    stations.each do |s|
      code = s[0]
      distance = s[2]
      station = MetroStation.find_by_code(code)
      trains.merge!(Hash[station.code.to_s,Hash[:address,station.address,:name, station.name,:distance, distance, :trains, trains_at_station(code)]])
    end
    trains.to_json
  end


  def trains_at_station code
    # station = MetroStation.find_by_code(code)
    s = WMataAPI.get("https://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{code}", query: { api_key: "#{Token}" })
    trains = s["Trains"].map {|s| s.values_at("Line","Min","LocationName","DestinationName")}
    trains = trains.map {|train| Hash[:train,Hash[:Line,train[0],:Min,train[1],:destination,train[3]]]}
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

  # def train_stations
  #   trains = Hash.new
  #   stations = distance_list
  #   stations.each do |s|
  #     code = s[0]
  #     station = MetroStation.find_by_code(code)
  #     trains.merge!(Hash[:address, station.address,)
  #   end
  #   trains.to_json
  # end
end

# require 'pry'
# t = WMataAPI.new
# binding.pry


