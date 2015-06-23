class Create < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :description
      t.timestamps null: false
    end

    create_table :answers do |t|
      t.integer :question_id
      t.text :description
      t.timestamps null: false
    end
  end
end
