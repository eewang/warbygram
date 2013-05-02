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

end