module ApplicationHelper
  include SortableTable::App::Helpers::ApplicationHelper  
  # QUESTION: Do we still need this?
  def load_chart(index = 0)
    load = [(current_load[index]*100).to_i, 100].min
    "http://chart.apis.google.com/chart?chs=50x25&cht=gom&chd=t:#{load}&chco=009900,00CC00,00FF00,FFFF00,FF8040,FF0000"
  end

  def color_syntaxed_gquery(q)
    str = q
    str = str.gsub(/([A-Z]+)/, '<span class="gql_operator">\1</span>')

    str = str.gsub(/(\()/, '<span class="gql_statement">\1')
    str = str.gsub(/(\))/, '\1</span>')

    str = str.gsub(/(\(\s*)(#{Gquery.gquery_hash.keys.join('|')})(\s*\))/, '\1<span class="gql_gquery_key">\2</span>\3')    
    str = str.gsub(/(\(\s*)(#{Group.keys.join('|')})(\s*\))/, '\1<span class="gql_group_key">\2</span>\3')    
    str.html_safe
  end

  def ga_tracker_code
    if Current.server_config.name.to_s == "transition_price"
      "UA-4089905-5"
    else
      "UA-4089905-4"
    end
  end

  # TODO refactor. Move to lib/ (seb 2010-10-11)
  # TODO documentation. Write a little documenation. 
  # QUESTION: Do we still need this?
  def current_load
    if RUBY_PLATFORM.downcase =~ /linux/
      %x['uptime'].split(" ")[9..-1].map{|c| c.chomp(',').to_f }
    elsif RUBY_PLATFORM.downcase =~ /darwin/ # Mac OS X
      %x['uptime'].split(" ")[9..-1].map{|c| c.gsub(",",".").to_f }
    else
      [0.0,0.0,0.0] # Can't determine load, just return 0.0 in that case.
    end
  end

  def asset_cache_name(name)
    if Rails.env.development? || Rails.env.builded?
      # we set config.perform_caching to true in development (to cache the Graph-qernel)
      # so we have to return false, otherwise changes won't be dodated
      false
    else
      "cache_#{name}"
    end
  end

  def has_update_statements?
    Current.scenario.update_statements.present?
  end

  def strip_html(str)
    # see: http://snippets.dzone.com/posts/show/4324
    str.gsub(/<\/?[^>]*>/, "")
  end


  def resolve_variables(txt)
    TextReplace.replace(txt)
  end
  alias_method :rv, :resolve_variables

  def table_defaults
    {:cellspacing => 0, :cellpadding => 0, :border => 0, :class => 'default'}
  end

  def cycles(html_attrs = {})
    class_name = cycle('odd', 'even')
    html_attrs[:class] = "#{html_attrs[:class]} #{class_name}"
    html_attrs
  end

  def flash_message(type = nil)
    if type.nil?
      flash_message(:notice) if flash[:notice]
      flash_message(:error) if flash[:error]
    else
      haml_tag 'div#flash', :class => type.to_s do
        haml_tag :p do
          haml_concat flash[type]
          haml_tag :small, link_to('close', '#', :onclick => "$('#flash').hide();")
        end
      end
    end
  end

  # TODO document - what the hell is %s/%s... (seb 2010-10-11)
  def last_etm_path(options = {})
    options[:include_action] = true if !options.has_key?(:include_action)
    if options[:include_action]
     "%s/%s" % [Current.setting.last_etm_controller_name, Current.setting.last_etm_controller_action]
    else
      "%s" % [Current.setting.last_etm_controller_name]
    end
  end

  # TODO refactor (what does this do?) (seb 2010-10-11)
  # Probably isnt used anyway
  def show_locale_files
    output = ''
    Dir["#{LOCALES_DIRECTORY}#{I18n.locale}.{rb,yml}"].sort.each do |locale_file|
      output << "\n#{locale_file.sub(Rails.root + "/", "")}:\n\n"
      counter, lineWidth = 1, 80
      lines = *open(locale_file).map(&:rstrip).each do |line|
        output << "#{sprintf('%3d', counter)}: #{line}\n"
        counter += 1
      end
    end
    output
  end

  def t_db(key)
    begin
      Translation.find_by_key(key).content.html_safe
    rescue
      "translation missing, #{I18n.locale.to_s.split('-').first} #{key}"
    end
  end

  def show_default_link?
    session[:selected_output_element].andand.to_s && session[:selected_output_element].to_s != session[:default_output_element].to_s
  end
  
  
  def login_and_come_back_path
    login_path(:redirect_to => request.env['REQUEST_PATH'])
  end
  
  def is_transitionprice?
    Current.server_config.name.to_s == 'transition_price'
  end
 
end
