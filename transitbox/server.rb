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
    params[:loc] = [38.9059620,-77.0423670]
    w = WMataAPI.new params[:loc]
    nearest = w.nearest_stations
    # binding.pry
  end

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: :get
    end
  end

  after do
    ActiveRecord::Base.connection.close
  end
end

# MetroStation.delete_all
# BusStation.delete_all
# BikeStation.delete_all
TransitApp.run! if $PROGRAM_NAME == __FILE__
