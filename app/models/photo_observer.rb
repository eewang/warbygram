class PhotoObserver < ActiveRecord::Observer
	def after_save(photo) # Need to know which photos are new to save all the information, not after p.save or p.first_or_create
		# Need logic to determine new photos
    message = {:channel => '/photos/new', :data => {:photo => photo}}
    uri = URI.parse(ENV['FAYE_SERVER'] + "/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
	end
end