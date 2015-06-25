class CreateBusStations < ActiveRecord::Migration
  def change
    create_table :bus_stations do |t|
      t.string :address
      t.string :stop_id
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
      t.timestamps null: false
    end
  end
end
