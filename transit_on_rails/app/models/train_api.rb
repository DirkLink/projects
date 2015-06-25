class TrainApi

  Token = Figaro.env.wmata_api_key
  def initialize loc
    @loc = loc
  end

  include HTTParty
  base_uri 'https://api.wmata.com'

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
    trains = []
    stations = distance_list
    stations.each do |s|
      code = s[0]
      distance = s[2]
      station = MetroStation.find_by_code(code)
      trains = trains.push(Hash[:address,station.address,:name, station.name,:distance, distance, :train, trains_at_station(code)])
    end
    # trains = Hash[:station, trains]
    trains = Hash[:station,trains]
    trains
  end


  def trains_at_station code
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