class BusApi

  Token = Figaro.env.wmata_api_key

  def initialize loc
    @loc = loc
  end

  include HTTParty
  base_uri 'https://api.wmata.com'

  def self.buses_at_stop code
    s = BusApi.get("https://api.wmata.com/NextBusService.svc/json/jPredictions", query: { StopID: "#{code}", api_key: "#{Token}" })
      if s["Predictions"]
        buses = s["Predictions"].map {|bus| Bus.new(bus)}
      end
  end


  def self.update_bus_stations
    BusStation.delete_all
    s = BusApi.get("/Bus.svc/json/jStops", query: { api_key: "#{Token}" })
    station_array = s["Stops"].map {|s| s.values_at("Name","StopID","Lat","Lon")}
    station_array.each do |station|
      BusStation.create! address: station[0], stop_id: station[1], lat: station[2],  long: station[3]
    end
  end

end