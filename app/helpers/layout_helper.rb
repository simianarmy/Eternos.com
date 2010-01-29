# $Id$
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  @@js = []
  @@google_api_loaded = false
  @@prototype_loaded = @@jquery_loaded = false
  @@layout = nil
  mattr_accessor :js, :google_api_loaded, :prototype_loaded, :jquery_loaded, :layout
  
  class << self
    def clear_js_cache
      RAILS_DEFAULT_LOGGER.debug "Clearing js includes"
      LayoutHelper.js = []
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
    !(response.layout.match %r(layouts/#{layout.to_s}$)).nil?
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def js_include(place, *args)
    js << args = args.reject {|a| js.include? a}.map { |arg| arg == :defaults ? arg : arg.to_s }
    js.flatten!
    RAILS_DEFAULT_LOGGER.debug "Javascript includes: " + js.join("\t")
    content_for(place.to_sym) { javascript_include_tag(*args) }
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
    request.protocol + 'ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js'
    #'prototype'
  end
  
  def scriptaculous
    request.protocol + 'ajax.googleapis.com/ajax/libs/scriptaculous/1.8.2/scriptaculous.js'
    #'scriptaculous'
  end
  
  # asset inclusion helpers
  def use_lightview_25
    stylesheet '/javascripts/lightview2.5/css/lightview.css'
    javascript 'lightview2.5/js/lightview'
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
    load_google_api {
      javascript_tag 'google.load("prototype", "1.6.1.0"); google.load("scriptaculous", "1.8.2");'
    }
    @@prototype_loaded = true
  end
  
  def use_jquery(context=:javascript)
    return if jquery_loaded
    load_google_api
    content_for(context) { 
      javascript_tag('google.load("jquery", "1.3.2"); google.load("jqueryui", "1.7.2");')
    }
    @@jquery_loaded = true
    # Make sure jquery doesn't conflict with any loaded prototype libs
    javascript 'application_jquery'
  end
  
  def use_scrollable
    use_jquery
    javascript 'jQuery/jquery.scrollable-1.0.1', 'jQuery/jquery.mousewheel', 'scrollable', 'slideshow'
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
    javascript 'flowplayer-3.1.4.min', js_min_unless_dev('flowplayer.playlist-3.0.7'), 
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
    javascript 'fckeditor/fckeditor', 'wysiwyg'
#      'http://yui.yahooapis.com/2.7.0/build/yahoo/yahoo-min.js',
#      'http://yui.yahooapis.com/2.7.0/build/get/get-min.js'
  end
  
  def use_accordion
    javascript scriptaculous, 'accordion'
    stylesheet 'accordion'
  end
  
  def use_calendar
    javascript 'datepicker'
    stylesheet 'datepicker'
  end
  
  def use_soundmanager
    content_for(:javascript) { "\n<!-- SM2 JS START -->\n"}
    javascript (RAILS_ENV == 'development') ? 'soundmanager2' : 'soundmanager2-nodebug-jsmin'
    #javascript 'page-player'
    javascript 'inlineplayer'
    #content_for(:javascript) { javascript_tag "soundManager.url = '/swf'" }
    content_for(:javascript) { "\n<!-- SM2 JS END -->\n"}
    stylesheet 'soundmanager2', 'inlineplayer'
    #stylesheet 'page-player'
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
    javascript "mootools-1.2-core-nc", "Swiff.Uploader", "Fx.ProgressBar", "FancyUpload2", "upload_form"
  end

  
  def use_timeline
    stylesheet 'timeline'
    
    use_prototip
    use_jquery
    use_lightview
    use_busy
    
    #javascript "http://static.simile.mit.edu/timeline/api-2.3.0/timeline-api.js?bundle=true" 
    javascript "timeline/timeline_ajax/simile-ajax-api.js", "timeline/timeline_js/timeline-api.js"
    javascript "timeline/events", "timeline/templates", "timeline/media", "timeline_helper", "date", "inflection"
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
   
  private
  
  def js_min_unless_dev(js)
    RAILS_ENV == 'development' ? js : "#{js}.min"
  end
end
