namespace :warby do

  desc "Update warby parker tag metadata"
  task :tags => :environment do
    Photo.get_warby_tag_metadata
    puts "'Save Warby tag metadata' task ran at #{Time.now}"
  end

  desc "Get warby parker-related photos via tag metadata"
  task :photos => :environment do
    Photo.save_warby_tagged_photos
    puts "'Save Warby tagged photos' task ran at #{Time.now}"
  end

end