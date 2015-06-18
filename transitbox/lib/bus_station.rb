require 'haversine'
class BusStation < ActiveRecord::Base

  def distance loc
    Haversine.distance([lat,long],loc).to_miles
  end
end