namespace :import do
		
	require 'csv'
	desc 'Imports product info CSV file into ActiveRecord table'
	task :glasses => :environment do

		def clean_sku(sku)
			if sku == "#REF!"
				""
			else
				sku
			end
		end

		glasses = CSV.open "lib/frames_productinfo.csv", headers: true, header_converters: :symbol
		glasses.each do |row|		
			name = row[:style]
			color = row[:color]
			collection = row[:collection]
			optical = row[:optical]
			sku = clean_sku(row[:sku])

			puts "#{name} - color: #{color} from collection #{collection} (sku: #{sku}) \n #{optical}"
			puts "................"
			Glasses.create!(
				:name => row[:style],
				:color => row[:color],
				:collection => row[:collection],
				:optical => row[:optical],
				:sku => clean_sku(row[:sku])
				) 
		end
	end

	desc 'Imports color info CSV file into ActiveRecord table'
	task :color => :environment do

		glasses = CSV.open "lib/frames_colors.csv", headers: true, header_converters: :symbol
		glasses.each do |row|		
			cc = row[:cc]
			color = row[:color]
			color_family = row[:color_family]
			color_assignment = row[:color_assignment]

			puts "cc: #{cc} || color: #{color} || color family: #{color_family} || color assignment: #{color_assignment}"
			puts "................"
			Color.find_or_create_by_cc!(
				:cc => row[:cc],
				:color => row[:color],
				:color_family => row[:color_family],
				:color_assignment => row[:color_assignment]
				) 
		end
	end
end