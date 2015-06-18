class Tables < ActiveRecord::Migration
  def change
    create_table :metro_stations do |t|
      t.string :name
      t.string :code
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
    end

    create_table :bike_stations do |t|
      t.string :address
      t.integer :station_id
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
    end

    create_table :bus_stations do |t|
      t.string :address
      t.string :route_id
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
    end
  end
end
