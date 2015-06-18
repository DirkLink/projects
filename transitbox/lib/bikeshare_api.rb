require 'httparty'
require 'json'
class BikeShareAPI
  # Token = File.read "./token"

  include HTTParty
  base_uri 'https://www.capitalbikeshare.com/data/stations/bikeStations.xml'

  def initialize
    #@headers = { "Authorization" => "token #{Token}"}
  end

  def self.update_table
    s = BikeShareAPI.get("")
    station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","id")}
    station_array.each do |station|
    BikeStation.create! address: station[0], station_id: station[1], lat: station[2], long: station[3]
    end
  end

  def stations
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