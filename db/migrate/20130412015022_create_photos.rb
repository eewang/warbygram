class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.string :location
      t.string :person
      t.timestamps
    end
  end
end
