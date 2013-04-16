class InstagramWrapper

  def tag_recent_media(options)
    tag = options[:tag] ? options[:tag] : nil
    Instagram.tag_recent_media(tag)
  end

  def media_search(options)
    lat = options[:lat] ? options[:lat] : nil
    lon = options[:lon] ? options[:lon] : nil
    dis = options[:distance] ? options[:distance] : 2012
    Instagram.media_search(lat, lon, :distance => dis)
  end

  def media_popular(options)
    Instagram.media_popular(options)
  end


  def user_media_feed(options)
    Instagram.user_media_feed(options)
  end

end
