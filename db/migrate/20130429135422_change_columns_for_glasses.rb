class ChangeColumnsForGlasses < ActiveRecord::Migration
  def change
		change_table :glasses do |t|
		  t.remove :type, :male
		end
  end
end
