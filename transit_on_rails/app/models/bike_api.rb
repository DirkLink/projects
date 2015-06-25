class BikeApi

  def initialize loc
    @loc = loc
  end

  include HTTParty
  base_uri 'https://www.capitalbikeshare.com/data/stations/bikeStations.xml'

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

  def self.station_info id
    s = BikeApi.get("")
    if s
      station_array = s["stations"]["station"].select {|station| station["id"].to_i==id}
      station_array.map {|station| Bike.new(station)}
    end
  end


  def self.update_table
    BikeStation.delete_all
    s = BikeApi.get("")
    station_array = s["stations"]["station"].map {|station| station.values_at("name","id","lat","long")}
    station_array.each do |station|
      BikeStation.create! address: station[0], station_id: station[1], lat: station[2], long: station[3]
    end
  end
end