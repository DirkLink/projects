class Column < ActiveRecord::Migration
  def change
      add_column :metro_stations, :address, :string
  end
end
