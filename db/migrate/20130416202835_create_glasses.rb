class CreateGlasses < ActiveRecord::Migration
  def change
    create_table :glasses do |t|

      t.timestamps
    end
  end
end
