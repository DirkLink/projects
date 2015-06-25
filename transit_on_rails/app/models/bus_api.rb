class BusApi

  Token = Figaro.env.wmata_api_key

  def initialize loc
    @loc = loc
  end

  include HTTParty
  base_uri 'https://api.wmata.com'


  def distance_list
    station_array = []
    stations = BusStation.all
    stations.each do |s|
      station_array.push([s.stop_id,s.address,s.distance(@loc)])
    end
    # station_array.compact!
    station_array.sort_by! {|a| a[2]}
    station_array[0..2]
  end

  def nearest_stops
    buses = []
      buses_list = distance_list
      buses_list.each do |s|
        code = s[0].to_i
        if buses_at_stop(code)
          distance = s[2]
          stop = BusStation.find_by_stop_id(code)
          # binding.pry
            buses = buses.push(Hash[:address, stop.address, :distance, distance, :bus, buses_at_stop(code)])
        end
      end
    buses = Hash[:buses,buses]
    buses
  end

  def buses_at_stop code
    s = BusApi.get("https://api.wmata.com/NextBusService.svc/json/jPredictions", query: { StopID: "#{code}", api_key: "#{Token}" })
      if s["Predictions"]
        buses = s["Predictions"].map {|bus| Bus.new(bus)}
      end
  end


  def self.update_bus_stations
    BusStation.delete_all
    s = BusStation.get("/Bus.svc/json/jStops", query: { api_key: "#{Token}" })
    station_array = s["Stops"].map {|s| s.values_at("Name","StopID","Lat","Lon")}
    station_array.each do |station|
      BusStation.create! address: station[0], stop_id: station[1], lat: station[2],  long: station[3]
    end
  end

end