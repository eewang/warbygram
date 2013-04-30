class RenameColumnsForGlasses < ActiveRecord::Migration
  def change
		change_table :glasses do |t|
		  t.remove :style
		  t.boolean :female
		  t.rename :gender, :male
		end
  end
end


