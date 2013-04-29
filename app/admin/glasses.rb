ActiveAdmin.register Glasses do
	index do
		column :id
		column "Style", :name
		column :color
		column :collection
		column "Optical / Sun ", :optical
		column "SKU", :sku
		column :female
		column :male
		default_actions
	end  
end
