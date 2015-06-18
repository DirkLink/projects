require 'httparty'
require 'json'

class WMataAPI
  # Token = File.read "./token"

  include HTTParty
  base_uri 'https://api.wmata.com'

  def initialize
    #@headers = { "Authorization" => "token #{Token}"}
  end

  def get_stations
    s = WMataAPI.get("/v1/search", query: { q: "artist:#{artist} + track:#{track}", type: "track"}) 
    # query: { q: "uprising", type: "track"}
    if s
      track_list = s["tracks"]["items"].map { |track| track.values_at("name", "uri") }
      track_list.first
    end
  end
end

# require 'pry'
# spot = WMataAPI.new
# binding.pry
