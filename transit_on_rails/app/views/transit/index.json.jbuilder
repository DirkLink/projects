json.station @nearest_metro do |metro|
  json.distance metro.distance(@loc)
  json.address metro.address
  json.name metro.name  

  json.train metro.trains do |train|
      json.(train, :line, :destination, :min)
  end
end

json.bike @nearest_bike do |bike|
  json.name bike.address
  json.distance bike.distance(@loc)
  json.nbBikes bike.stations.nbBikes
  json.nbEmptyDocks bike.stations.nbEmptyDocks
end

json.buses @nearest_bus do |buses|
  json.distance buses.distance(@loc)
  json.address buses.address

  json.bus buses.buses_at do |bus|
      json.(bus, :Minutes, :directionText, :RouteID)
  end
end