class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.string :comment
    	t.integer :photo_id
    	t.string :comment_date
    	t.string :instagram_user_id
    	t.string :comment_id

      t.timestamps
    end
  end
end
