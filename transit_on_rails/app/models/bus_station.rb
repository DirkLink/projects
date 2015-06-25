class BusStation < ActiveRecord::Base

  def buses_at
    @_buses ||= BusApi.buses_at_stop(stop_id)
  end

  def distance loc
    Haversine.distance([lat.to_f,long.to_f],loc).to_miles
  end

  def self.nearest_stations loc
    all.sort_by {|station| station.distance(loc)}[0..2]
  end
end
