# $Id$
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper

  class JS
    cattr_accessor :js_includes
    @@js_includes = {}
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
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:javascript) { javascript_include_tag(*args) }
  end
  
  def header(text)
    content_for(:header) { text }
  end
  
  def title_icon(src)
    content_for(:title_icon) { src }
  end
  
  # Where we get prototype js from
  def prototype
    'http://ajax.googleapis.com/ajax/libs/prototype/1.6/prototype.js'
  end
  
  def scriptaculous
    'http://ajax.googleapis.com/ajax/libs/scriptaculous/1.8.2/scriptaculous.js'
  end
  
  # asset inclusion helpers
  def use_orig_lightview
    stylesheet '/javascripts/lightview2.5/css/lightview.css'
    js_include prototype, scriptaculous, 'lightview2.5/js/lightview'
  end
  
  def use_lightview
    stylesheet "/javascripts/lightview/css/lightview.css"
    use_lightview_only_js
  end
  
  def use_lightview_only_js
    js_include prototype, scriptaculous, "lightview/js/lightview" 
  end
  
  def use_jquery
    js_include 'jQuery/jquery-1.2.6', 'jQuery/jquery-ui'
  end
  
  def use_scrollable
    use_jquery
    js_include 'jQuery/jquery.scrollable-1.0.1', 'jQuery/jquery.mousewheel', 'scrollable', 'slideshow'
    stylesheet 'scrollable', 'scrollable-navig'
  end
  
  def use_flash
    js_include 'swfobject'
  end
  
  def use_flashplayer
    js_include 'flowplayer-3.0.0-rc5.min', '/javascripts/flowplayer.js'
  end
  
  def use_js_cookies
    js_include 'cookiejar', 'application'
  end
  
  def use_lowpro
    js_include prototype, scriptaculous, 'lowpro', 'defaultvalueactsashint', 'behaviors'
  end
  
  def use_prototip
    use_lowpro
    js_include 'prototip'
    stylesheet 'prototip'
  end
  
  def use_form
    use_lowpro
    js_include 'CustomFormElements'
    use_busy
  end
  
  def use_tabs
    js_include "http://api.maps.yahoo.com/v3.0/fl/javascript/apiloader.js?appid=#{YAHOO_APP_ID}", 
      'tabs', prototype
    stylesheet 'tabs'
  end
  
  def use_busy
    js_include 'application', 'cvi_busy_lib'
  end
  
  def use_wysiwyg
    js_include 'fckeditor/fckeditor', 'wysiwyg'
#      'http://yui.yahooapis.com/2.7.0/build/yahoo/yahoo-min.js',
#      'http://yui.yahooapis.com/2.7.0/build/get/get-min.js'
  end
  
  def use_accordion
    js_include scriptaculous, 'accordion'
    stylesheet 'accordion'
  end
  
  def use_calendar
    js_include 'datepicker'
    stylesheet 'datepicker'
  end
  
  def use_soundmanager
    content_for(:javascript) { "\n<!-- SM2 JS START -->\n"}
    js_include (RAILS_ENV == 'development') ? 'soundmanager2' : 'soundmanager2-nodebug-jsmin'
    #js_include 'page-player'
    js_include 'inlineplayer'
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
    js_include 'jQuery/jquery.autocomplete', 'application_jquery'
  end
  
  def use_uploader
    @no_prototype = true
    stylesheet "content_upload"
    js_include "mootools-1.2-core-nc", "Swiff.Uploader", "Fx.ProgressBar", "FancyUpload2", "upload_form"
  end
  
  def style_hidden_if(expression)
    expression ? "display:none;" : ""
  end
  
  private
  
  # Helper to prevent duplicate includes of javascript files 
  def js_include(*args)
    js = []
    args.each do |a| 
      unless JS.js_includes.key? a
        js << a
        JS.js_includes[a] = true
      end
    end
    javascript *js
  end

end
