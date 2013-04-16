class CreateGlasses < ActiveRecord::Migration
  def change
    create_table :glasses do |t|
    	t.string "name"
    	t.string "type"
    	t.string "gender"
    	t.string "image"

      t.timestamps
    end
  end
end
