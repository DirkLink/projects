class BikeApi

  def initialize loc
    @loc = loc
  end

  include HTTParty
  base_uri 'https://www.capitalbikeshare.com/data/stations/bikeStations.xml'

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