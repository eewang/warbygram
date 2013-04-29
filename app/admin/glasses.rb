ActiveAdmin.register Glasses do
	scope :all
	scope :optical
	scope :sunwear

  index :as => :grid do |glasses|
    div do
      a :href => admin_glass_path(glasses) do
        image_tag(glasses.image)
      end
    end
    a truncate(glasses.name), :href => admin_glass_path(glasses)
  end

  show :name => :name

	# index do
	# 	column :id
	# 	column "Style", :name
	# 	column :color
	# 	column :collection
	# 	column "Optical / Sun ", :optical
	# 	column "SKU", :sku
	# 	column :female
	# 	column :male
	# 	default_actions
	# end  
end
