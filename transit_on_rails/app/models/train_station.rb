class TrainStation < ActiveRecord::Base
  
  def trains
    @_trains ||= TrainApi.trains_at_station(code)
  end

  def distance loc
    Haversine.distance([lat.to_f,long.to_f],loc).to_miles
  end

  def self.nearest_stations loc
    all.sort_by {|station| station.distance(loc)}[0..2]
  end
end
