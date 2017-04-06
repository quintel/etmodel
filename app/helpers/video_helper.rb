module VideoHelper
  # inserts the right video player according to global configuration
  #
  def smart_video_player(video_id, opts = {})
    if APP_CONFIG[:standalone]
      local_video_player(video_id, opts)
    else
      vimeo_video_player(video_id, opts)
    end
  end

  # embed vimeo player inside an iframe
  #
  def vimeo_video_player(video_id, opts = {})
    defaults = {
      width: 510,
      height: 290,
      frameborder: 0,
      src: "https://player.vimeo.com/video/#{video_id}"
    }
    content_tag :iframe, nil, defaults.merge(opts)
  end

  # HTML5 video tag using video-js player
  # This requires a local copy of the files in ogv and m4v formats
  #
  def local_video_player(video_id, opts = {})
    ogv = "/videos/#{video_id}.ogv"
    mp4 = "/videos/#{video_id}.m4v"
    return unless local_video_exists?(ogv) && local_video_exists?(mp4)
    defaults = {
      id: 'js_video_player',
      width: 510,
      height: 290,
      class: 'video-js vsj-default-skin',
      controls: true,
      preload: false,
      poster: '/assets/video_poster_image.png'
    }
    include_video_js_files
    content_tag :video, defaults.merge(opts) do
      "<source src='#{mp4}' type='video/mp4'/>
       <source src='#{ogv}' type='video/ogg'/>".html_safe
    end
  end

  def include_video_js_files
    return if @video_js_included
    content_for :head do
      stylesheet_link_tag '/video-js/video-js.min.css'
      javascript_include_tag '/video-js/video.min.js'
    end
    @video_js_included = true
  end

  def local_video_exists?(url)
    File.exists?("#{Rails.root}/public/#{url}")
  end
end
