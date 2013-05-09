namespace :warby do

  desc "Update warby parker tag metadata"
  task :tags => :environment do
    Photo.get_warby_tag_metadata
    puts "'Save Warby tag metadata' task ran at #{Time.now}"
  end

  desc "Get warby parker-related photos via tag metadata"
  task :all_photos => :environment do
    Photo.save_warby_tagged_photos
    puts "'Save all Warby tagged photos' task ran at #{Time.now}"
  end

  desc "Get just #warbyparker or #warby photos"
  task :some_photos => :environment do
    photo_count_before = Photo.count
    photos = []
    Photo::WARBY_TAGS.each do |tag|
      photos << Photo.save_tagged_photos(tag)
      sleep 5
    end
    photo_count_after = Photo.count
    puts "'Saved some Warby tagged photos' task ran at #{Time.now}; #{photo_count_after - photo_count_before} new photos"
  end

  desc "Get location-based @warby pics"
  task :get_location_photos => :environment do
    photo_array = Photo.order(:nearby_count).delete_if { |i| i.nearby_count.nil? }.reverse
    photo_array.collect! {|item| item if (photo_array.index(item) % (photo_array.size / 10)) == 0 }.compact!
    photo_array.each do |photo|
      photo_count_before = Photo.count
      Photo.check_location(photo.latitude, photo.longitude, 5000)
      photo_count_after = Photo.count
      puts "Location checked #{photo_array.index(photo) + 1} of #{photo_array.size} at #{Time.now}. #{photo_count_after - photo_count_before} new photos"
      sleep 60
    end
  end

end