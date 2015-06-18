require 'haversine'
class MetroStation < ActiveRecord::Base
  def distance loc
    Haversine.distance([lat,long],loc).to_miles
  end
end