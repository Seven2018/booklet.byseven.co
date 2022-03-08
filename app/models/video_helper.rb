module VideoHelper

  # Legacy method to create embedded links (or iframes) from Youtube and Loom sources

  def self.embed_video(video_url)
    if video_url =~ /^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/
      video_id = "https://www.youtube.com/embed/" + video_url.split("=")[1]
      # content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{video_id}", allowfullscreen: "allowfullscreen")
    elsif video_url =~ /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]loom+)\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/
      video_id = video_url.split("/").last
      # content_tag(:iframe, nil, src: "//www.loom.com/embed/#{video_id}", allowfullscreen: "allowfullscreen")
    end
  end
end
