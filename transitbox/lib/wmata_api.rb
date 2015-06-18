require 'httparty'
require 'json'

class WMataAPI
  Token = File.read "./token"

  include HTTParty
  base_uri 'https://api.wmata.com'

  def initialize
    #@headers = { "Authorization" => "token #{Token}"}
  end

  def stations
    s = WMataAPI.get("https://api.wmata.com/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
    if s

      station_array = s["stations"]["station"].map {|station| station.values_at("name","lat","long","nbEmptyDocks","nbBikes")}
      station_array.map {|station| Hash[:name,station[0],:lat,station[1],:long,station[2],:nbEmptyDocks,station[3],:nbBikes,station[4]]}
    end
  end

  def get_track artist, track

    s = WMataAPI.get("/v1/search", query: { q: "artist:#{artist} + track:#{track}", type: "track"}) 
    # query: { q: "uprising", type: "track"}
    if s
      track_list = s["tracks"]["items"].map { |track| track.values_at("name", "uri") }
      track_list.first
    end
  end
end

# require 'pry'
# t = WMataAPI.new
# binding.pry


