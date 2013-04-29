require 'csv'
desc 'Imports product info CSV file into ActiveRecord table'
task :import => :environment do

	glasses = CSV.open "lib/frames_productinfo.csv", headers: true, header_converters: :symbol
	glasses.each do |row|		
		name = row[:style]
		color = row[:color]
		collection = row[:collection]
		optical = row[:optical]
		sku = row[:sku]
	
	# remove style (the same as name) from activerecord
	# remove 'gender' column, add male and female column
	
		if row[:male] == 1

			# i want to set male columns set to 1 to be marked 'male'
			# i want to set female columns set to 1 to be marked 'female'
			# i want active columns set to 1 to be marked 'active'
		end

		puts "#{name} - color: #{color} from collection #{collection} (sku: #{sku}) \n #{optical}"
		puts "................"
		Glasses.create!(
			:name => row[:style],
			:color => row[:color],
			:collection => row[:collection],
			:optical => row[:optical],
			:sku => row[:sku]
			) 

	end

end