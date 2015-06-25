class BikeStation < ActiveRecord::Base

  def stations
    @_stations ||= BikeApi.station_info(station_id).first
  end

  def distance loc
    Haversine.distance([lat.to_f,long.to_f],loc).to_miles
  end

  def self.nearest_stations loc
    all.sort_by {|station| station.distance(loc)}[0..2]
  end
end
