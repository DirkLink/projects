class CreateTrainStations < ActiveRecord::Migration
  def change
    create_table :train_stations do |t|
      t.string :name
      t.string :code
      t.string :address
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
      t.timestamps null: false
    end
  end
end
