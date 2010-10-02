# $Id$
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  @@js = {}
  @@google_api_loaded = false
  @@prototype_loaded = @@jquery_loaded = false
  @@layout = nil
  mattr_accessor :js, :google_api_loaded, :prototype_loaded, :jquery_loaded, :layout
  
  class << self
    def clear_js_cache
      RAILS_DEFAULT_LOGGER.debug "Clearing js includes"
      LayoutHelper.js = {}
      LayoutHelper.google_api_loaded = false
      LayoutHelper.prototype_loaded = false
      LayoutHelper.jquery_loaded = false
    end
  end
  
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
 
  def using_layout?(layout)
    response.layout && !(response.layout.match %r(layouts/#{layout.to_s}$)).nil?
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def inner_stylesheet(*args)  
    content_for(:inner_head) { stylesheet_link_tag(*args) }
  end
  
  def js_include(place, *args)
    Rails.logger.debug "JS INCLUDES: #{args.inspect}"
    p = place.to_sym
    (js[p] ||= []) << args = args.reject {|a| js[p] && js[p].include?(a)}.map { |arg| arg == :defaults ? arg : arg.to_s }
    js[p].flatten!
    RAILS_DEFAULT_LOGGER.debug "Javascript #{p} includes: " + js[p].join("\t")
    content_for(p) { javascript_include_tag(*args) }
  end
  
  def javascript(*args)
    js_include(:javascript, *args)
  end
  
  def javascript_place(position, *args)
    js_include(position, *args)
  end
  
  def header(text)
    content_for(:header) { text }
  end
  
  def title_icon(src)
    content_for(:title_icon) { src }
  end
  
  def url_for_image_path(path)
    ActionController::Base.asset_host + '/' + image_path(path)
  end
  
  # Where we get prototype js from
  def prototype
    #request.protocol + 'ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js'
    'prototype'
  end
  
  def scriptaculous
    #request.protocol + 'ajax.googleapis.com/ajax/libs/scriptaculous/1.8.2/scriptaculous.js'
    'scriptaculous.js?load=effects,controls,slider'
  end
  
  # asset inclusion helpers
  def use_lightview_25
    stylesheet '/javascripts/lightview2.5.2.1/css/lightview.css'
    javascript 'lightview2.5.2.1/js/lightview'
  end
  
  def use_lightview
    use_lightview_25
    #stylesheet "/javascripts/lightview/css/lightview.css"
    #use_lightview_only_js
  end
  
  def use_lightview_only_js
    javascript "lightview/js/lightview" 
  end
  
  # wow this js include business is getting complicated
  def load_google_api
    content = ''
    content += javascript_include_tag(request.protocol + "www.google.com/jsapi?key=#{AppConfig.google_api_key}") unless @@google_api_loaded
    content += yield if block_given?
    @@google_api_loaded = true
    
    content_for(:js_libs) {      
      concat content
    }
  end
  
  def load_prototype
    return if prototype_loaded || @no_prototype
    # load_google_api {
    #       javascript_tag 'google.load("prototype", "1.6.1.0"); google.load("scriptaculous", "1.8.2");'
    #     }
    javascript_place :js_libs, prototype, scriptaculous

    @@prototype_loaded = true
  end
  
  # Required when using both Prototype & jQuery - requires exact load order to work in IE
  def load_jquery_prototype_compat_mode
    javascript_place :js_libs, 'jQuery/jquerytools-1.1.2.min', 'application_jquery', prototype, scriptaculous
    @@prototype_loaded = true
    @@jquery_loaded = true
  end
  
  def use_jquery(context=:javascript)
    return if jquery_loaded
    #load_google_api
    content_for(context) { 
      #javascript_tag('google.load("jquery", "1.3.2"); google.load("jqueryui", "1.7.2");')
      javascript 'jQuery/jquerytools-1.1.2.min', 'application_jquery'
    }
    @@jquery_loaded = true
    # Make sure jquery doesn't conflict with any loaded prototype libs
  end

  # default set of jQuery Tools + jQuery 1.3.2
  def use_jquerytools
    #use_jquery # required for ie bug?
    javascript_place :js_libs, 'jQuery/jquerytools-1.1.2.min', 'application_jquery'
    #@@jquery_loaded = true
  end
    
  def use_scrollable
    # fault set of jQuery Tools + jQuery 1.3.2
    use_jquerytools
    #javascript 'slideshow'
    stylesheet 'scrollable', 'scrollable-navig'
  end
  
  def use_flash
    #content_for(:javascript) { 
    #  javascript_tag 'google.load("swfobject", "2.2");' 
    #}
    # load swfobject.js in headers
    content_for(:head) {
      javascript_include_tag 'swfobject'
    }
    javascript 'backtothehtml'
  end
  
  def use_flashplayer
    use_jquery
    stylesheet 'media'
    javascript 'flowplayer-3.1.4.min', 'flowplayer.playlist-3.0.7.min', 
      '/javascripts/flowplayer.js'
  end
  
  def use_js_cookies
    javascript 'cookiejar', 'application'
  end
  
  def use_lowpro
    load_prototype
    javascript 'lowpro', 'defaultvalueactsashint', 'behaviors'
  end
  
  def use_prototip
    use_lowpro
    javascript 'prototip2.1.0.1/js/prototip'
    stylesheet 'prototip'
  end
  
  def use_form
    use_lowpro
    #javascript 'CustomFormElements'
    use_busy
  end
  
  def use_tabs
    stylesheet 'tabs'
    javascript request.protocol + "api.maps.yahoo.com/v3.0/fl/javascript/apiloader.js?appid=#{YAHOO_APP_ID}", 
      'tabs'
  end
  
  def use_busy
    javascript 'application', 'cvi_busy_lib'
  end
  
  def use_wysiwyg
    use_jquery
    javascript 'ckeditor/ckeditor.js', 'ckeditor/adapters/jquery.js', 'jQuery/jquery.form.js', 'wysiwyg'
  end
  
  def use_accordion
    javascript scriptaculous, 'accordion'
    stylesheet 'accordion'
  end
  
  def use_calendar
    javascript 'datepicker'
    stylesheet 'datepicker'
  end
  
  def use_soundmanager(options={})
    options.reverse_merge!({:style => 'inline'})
    
    content_for(:javascript) { "\n<!-- SM2 JS START -->\n"}
    javascript (RAILS_ENV == 'development') ? 'soundmanager2' : 'soundmanager2-nodebug-jsmin'
    #content_for(:javascript) { javascript_tag "soundManager.url = '/swf'" }
    content_for(:javascript) { "\n<!-- SM2 JS END -->\n"}
    
    if options[:style] == 'pageplayer'
      javascript 'page-player'
      stylesheet 'soundmanager2', 'pageplayer'
    else
      javascript 'inlineplayer'
      stylesheet 'inlineplayer'
    end
  end
  
  def use_media
    use_soundmanager
    use_flashplayer
  end
  
  def use_autocomplete
    use_jquery
    stylesheet 'jquery.autocomplete'
    javascript 'jQuery/jquery.autocomplete'
  end
  
  def use_uploader
    @no_prototype = true
    stylesheet "content_upload"
    javascript "mootools-1.2.4-core-yc", "Swiff.Uploader", "Fx.ProgressBar", "FancyUpload2", "upload_form"
  end

  def use_image_gallery
    stylesheet 'image_gallery'
    use_jquery
    javascript 'jQuery/jquery-ui.min', 'image_gallery'
  end
  
  def use_timeline
    stylesheet 'timeline'
    
    #javascript "http://static.simile.mit.edu/timeline/api-2.3.0/timeline-api.js?bundle=true" 
    javascript "timeline/timeline_ajax/simile-ajax-api.js", "timeline/timeline_js/timeline-api.js"
    javascript "timeline_helper", "date", "inflection"
  end
  
  def use_scrollbar
    stylesheet 'scrollbar'
    javascript 'slider', 'scroller'
    #javascript 'livepipe-ui/livepipe', 'livepipe-ui/scrollbar'
  end
  
  def load_timeline_js
    # this is supposed to work ... but getting errors in 
    #javascript_tag("
    #  Timeline_ajax_url='http://#{request.host}/javascripts/timeline/timeline_ajax/simile-ajax-api.js';
    #  Timeline_urlPrefix='http://#{request.host}/javascripts/timeline/timeline_js/';
    #  Timeline_parameters='bundle=true';") +
    #javascript_include_tag("timeline/timeline_ajax/simile-ajax-api.js", "timeline/timeline_js/timeline-api.js", "timeline/events", "timeline/templates", "timeline_helper")
  end
  
  def style_hidden_if(expression)
     expression ? "display:none;" : ""
  end
   
  def members_tab_class_active?(page)
    (controller.controller_name == page) ? 'active' : 'inact'
  end
  
  private
  
  def js_min_unless_dev(js)
    RAILS_ENV == 'development' ? js : "#{js}.min"
  end
end
