require 'sinatra/base'
require 'tilt/erubis' # Fixes a warning
require 'rack/cors'
require 'pry'
require './db/setup'
require './lib/all'

class TransitApp < Sinatra::Base
  enable :logging
  enable :method_override
  enable :sessions

  # set :session_secret, (ENV["SESSION_SECRET"] || "development")

  get "/transit" do
    # loc  = [params[:latitude].to_f,params[:longitude].to_f]
    loc = [38.9059620,-77.0423670]
    w = WMataAPI.new loc
    b = BikeShareAPI.new loc
    nearest_metro = w.nearest_stations
    nearest_bus = w.nearest_stops
    nearest_bike = b.nearest_stations
    # a = nearest_metro.concat(nearest_bike.concat(nearest_bus))
    a = [nearest_metro, nearest_bike, nearest_bus]
    return a.to_json


  end

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  before do
    headers["Content-Type"] = "application/json"
  end

  after do
    ActiveRecord::Base.connection.close
  end
end

# MetroStation.delete_all
# BusStation.delete_all
# BikeStation.delete_all
TransitApp.run! if $PROGRAM_NAME == __FILE__
