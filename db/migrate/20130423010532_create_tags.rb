class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
    	t.integer :photos_id
    	t.string :photos_user

      t.timestamps
    end
  end
end
