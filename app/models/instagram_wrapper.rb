class InstagramWrapper

  def tag_recent_media(options)
    tag = options[:tag] ? options[:tag] : nil
    Instagram.tag_recent_media(tag)
  end

  def media_search(options)
    lat = options[:lat]
    lon = options[:lon]
    dis = options[:distance] ||= 2012
    max_time = options[:max_timestamp]
    min_time = options[:min_timestamp]
    Instagram.media_search(lat, lon, :distance => dis, :max_timestamp => max_time, :min_timestamp => min_time)
  end

# 40.74451,-73.990131

  def media_popular(options)
    Instagram.media_popular(options)
  end

  def user_media_feed(options)
    Instagram.user_media_feed(options)
  end

  def tag_search(options) # InstagramWrapper.new({:tag => "warbyparker"})
    tag = options[:tag]
    Instagram.tag_search(tag)
  end
  
end
