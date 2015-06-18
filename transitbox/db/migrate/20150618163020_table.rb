class Table < ActiveRecord::Migration
  def change
    change_table :bus_stations do |t|
      t.rename :route_id, :stop_id
    end
  end
end
