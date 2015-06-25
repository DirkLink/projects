class BusStation < ActiveRecord::Base

  def buses
    @_buses ||= BusApi.buses_at_stop(stop_id)
  end

  def distance loc
    Haversine.distance([lat.to_f,long.to_f],loc).to_miles
  end

end
