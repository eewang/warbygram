class CreateInstagramUsers < ActiveRecord::Migration
  def change
    create_table :instagram_users do |t|
      t.string :user_name
      t.string :full_name
      t.string :profile_picture
      t.string :uid

      t.timestamps
    end
  end
end
