require 'httparty'
require 'json'

class WMataAPI
  Token = File.read "./token.txt"

  include HTTParty
  base_uri 'https://api.wmata.com'

  def initialize
    #@headers = { "Authorization" => "token #{Token}"}
  end

  def bus_stops
    s = WMataAPI.get("https://api.wmata.com/Bus.svc/json/jStops", query: { api_key: "#{Token}" })
  end

  def train_stations
    s = WMataAPI.get("https://api.wmata.com/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
    # if s

    #   station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","nbEmptyDocks","nbBikes")}
    #   station_array.map {|station| Hash[:name,station[0],:lat,station[1],:long,station[2],:nbEmptyDocks,station[3],:nbBikes,station[4]]}
    # end
  end
end

require 'pry'
t = WMataAPI.new
binding.pry


