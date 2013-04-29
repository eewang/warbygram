class CreateWarbyTags < ActiveRecord::Migration
  def change
    create_table :warby_tags do |t|
      t.string :tag
      t.integer :count
      t.timestamps
    end
  end
end
