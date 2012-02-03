module VideoHelper
  # HTML5 video tag using video-js player
  #
  def local_video_player(video_id, opts = {})
    defaults = {
      :id       => 'js_video_player',
      :width    => 510,
      :height   => 290,
      :class    => 'video-js vsj-default-skin',
      :controls => true,
      :preload  => false
    }
    include_video_js_files
    content_tag :video, defaults.merge(opts) do
      content_tag :source, nil, {:src => "/videos/#{video_id}.mp4", :type => 'video/mp4'}
      content_tag :source, nil, {:src => "/videos/#{video_id}.ogv", :type => 'video/ogg'}
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
end
