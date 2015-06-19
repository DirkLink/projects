require 'haversine'
class MetroStation < ActiveRecord::Base
  def distance loc
    Haversine.distance([lat.to_f,long.to_f],loc).to_miles
  end
end