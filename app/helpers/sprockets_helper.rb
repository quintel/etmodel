module SprocketsHelper

  def sprocket_include_tag(name)
    javascript_include_tag "/sprockets/%s.js" % [name.to_s]
  end
  
  def sprocket_page_init(name)
    sprocket_include_tag("%s.page" % name)
  end
  
  def sprocket_layout_init(name)
    sprocket_include_tag("%s.layout" % name)
  end
end