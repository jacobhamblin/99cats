class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.integer :birth_date 
      t.string :color
      t.string :name, null: false
      t.string :sex
      t.text :description

      t.timestamps null: false
    end
  end
end
