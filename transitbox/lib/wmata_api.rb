require 'httparty'
require 'json'

class WMataAPI
  Token = File.read "./token.txt"

  include HTTParty
  base_uri 'https://api.wmata.com'

  def initialize
    #@headers = { "Authorization" => "token #{Token}"}
  end

  def trains_at_station loc
    s = WMataAPI.get("https://api.wmata.com/StationPrediction.svc/json/GetPrediction/All", query: { api_key: "#{Token}" })
    binding.pry
    trains = s["Trains"].map {|s| s.values_at("Line","Min","LocationName","DestinationName")}
  end

  def self.update_metro_stations
    s = WMataAPI.get("/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
    station_array = s["Stations"].map {|s| s.values_at("Name","Lat","Lon","Code")}
    station_array.each do |station|
      MetroStation.create! name: station[0], lat: station[1], long: station[2], code: station[3]
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

  def train_stations
    s = WMataAPI.get("/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
  end
end

require 'pry'
t = WMataAPI.new
binding.pry


