require 'httparty'
require 'json'

class WMataAPI
  Token = File.read "./token.txt"

  include HTTParty
  base_uri 'https://api.wmata.com'

  def initialize
    #@headers = { "Authorization" => "token #{Token}"}
  end

  def update_metro_stations
    s = WMataAPI.get("")
    station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","id")}
    station_array.each do |station|
      MetroStation.create! address: station[0], station_id: station[1], lat: station[2], long: station[3]
    end
  end

  def bus_stops
    s = WMataAPI.get("/Bus.svc/json/jStops", query: { api_key: "#{Token}" })

  end

  def train_stations
    s = WMataAPI.get("/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
    station_array = s["Stations"].map {|s| s.values_at("Name","Code","Lat","Lon")}
  end
end

require 'pry'
t = WMataAPI.new
binding.pry


