class TrainStation < ActiveRecord::Base
  
  def distance loc
    Haversine.distance([lat.to_f,long.to_f],loc).to_miles
  end

  def self.nearest_stations loc
    all.sort_by {|station| station.distance(loc)}[0..2]
  end

  def as_json opts
    {
      type: "metro",
      lat: lat.to_s,
      long: long.to_s,
      name: name,
      address: address,
      trains: TrainApi.trains_at_station(code).map do |t|
        {
          line: t.line,
          destination: t.destination,
          min: t.min
        }
      end
    }
  end

end
