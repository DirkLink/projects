require 'httparty'
require 'json'
class BikeShareAPI
  # Token = File.read "./token"

  include HTTParty
  base_uri 'https://www.capitalbikeshare.com/data/stations/bikeStations.xml'

  def initialize loc
      #@headers = { "Authorization" => "token #{Token}"}
      @loc = loc
  end

  def self.update_table
    s = BikeSharePI.get("")
    station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","id")}
    station_array.each do |station|
    BikeStation.create! address: station[0], station_id: station[1], lat: station[2], long: station[3]
    end
  end

  def distance_list
      station_array = []
      stations = BikeStation.all
      info = station_info
      stations.each do |s|
        station_array.push([s.station_id,s.address,s.distance(@loc)])
      end
      station_array.sort_by! {|a| a[2]}
      station_array[0..2]
    end

    def nearest_stations
      bikes = Hash.new
      stations = distance_list
      stations.each do |s|
        id = s[0]
        distance = s[2]
        station = BikeStation.find_by_station_id(id)
        bikes.merge!(Hash[station.station_id.to_s,Hash[:address,station.address,:distance, distance, :bikes, trains_at_station(code)]])
      end
      bikes.to_json
    end


    def bikes_at_station code
      # station = MetroStation.find_by_code(code)
      s = WMataAPI.get("https://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{code}", query: { api_key: "#{Token}" })
      bikes = s["Trains"].map {|s| s.values_at("Line","Min","LocationName","DestinationName")}
      trains = trains.map {|train| Hash[:train,Hash[:Line,train[0],:Min,train[1],:destination,train[3]]]}
    end

  def station_info
    s = BikeShareAPI.get("")
    if s
      station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","nbEmptyDocks","nbBikes")}
      station_array = station_array.map {|station| Hash[:name,station[0],:lat,station[1],:long,station[2],:nbEmptyDocks,station[3],:nbBikes,station[4]]}
    end
    station_array
  end
end

# require 'pry'
# bikes = BikeShareAPI.new
# binding.pry
# q["stations"]["station"].map {|station| station.values_at("name","lat","long")}
# q = HTTParty.get("http://www.capitalbikeshare.com/data/stations/bikeStations.xml")