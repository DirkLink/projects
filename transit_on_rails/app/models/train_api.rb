class TrainApi

  Token = Figaro.env.wmata_api_key
  def initialize loc
    @loc = loc
  end

  include HTTParty
  base_uri 'https://api.wmata.com'

  def self.trains_at_station code
    # station = MetroStation.find_by_code(code)
    s = TrainApi.get("https://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{code}", query: { api_key: "#{Token}" })
    trains = s["Trains"].map {|s| Train.new(s)}
  end

  def self.update_metro_stations
    TrainStation.delete_all
    s = TrainApi.get("/Rail.svc/json/jStations", query: { api_key: "#{Token}" })
    station_array = s["Stations"].map {|s| s.values_at("Name","Lat","Lon","Code","Address")}
    station_array.each do |station|
      TrainStation.create! name: station[0], lat: station[1], long: station[2], code: station[3], address: station[4]["Street"]
    end
  end

end