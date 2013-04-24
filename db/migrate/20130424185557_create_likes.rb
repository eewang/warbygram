class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :photo
      t.references :instagram_user
      t.timestamps
    end
  end
end
