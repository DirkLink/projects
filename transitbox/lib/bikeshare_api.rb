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
    s = BikeShareAPI.get("")
    station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","id")}
    station_array.each do |station|
    BikeStation.create! address: station[0], station_id: station[1], lat: station[2], long: station[3]
    end
  end

  def distance_list
      station_array = []
      stations = BikeStation.all
      stations.each do |s|
        station_array.push([s.station_id,s.address,s.distance(@loc)])
      end
      station_array.sort_by! {|a| a[2]}
      station_array[0..2]
    end

    def nearest_stations
      bikes = []
      stations = distance_list
      stations.each do |s|
        id = s[0]
        distance = s[2]
        station = BikeStation.find_by_station_id(id)
        info = station_info(id)
        # binding.pry
        # bikes = station.push(Hash[:distance, distance])
        bikes = bikes.push(Hash[:name, station.address,:nbBikes, info.first[:nbBikes], :nbEmptyDocks, info.first[:nbEmptyDocks], :distance, distance])
      end
      bikes = Hash[:bike,bikes]
      bikes
    end

  def station_info id
    s = BikeShareAPI.get("")
    if s
      station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","nbEmptyDocks","nbBikes","id")}
      station_array = station_array.select {|station| station[5].to_i==id}
      station_array = station_array.map {|station| Hash[:name,station[0],:nbBikes,station[4],:nbEmptyDocks,station[3]]}
    end
    station_array
  end
end
