# Author:: Daniel Lopes
# WebSite:: http://www.areacriacoes.com.br
require 'action_view'

module ActionView #:nodoc:
  module Helpers # :nodoc:
    module SwfObjectHelper # :nodoc:
      def self.included(base)
        base.class_eval do
          include InstanceMethods
        end
      end
      module InstanceMethods
	      	
        # Returns a set of tags that display a SWF in HTML page.
        #
        # Options:
        # * <tt>:div_id</tt> - the HTML +id+ of the +div+ element that is used to contain the Flash object, the content of this DIV will be replaced for Flash content."
        # * <tt>:flash_id</tt> - the +id+ of the Flash object itself.
        # * <tt>:background_color</tt> - the background color of the Flash object; default white
        # * <tt>:flash_version</tt> - the version of the Flash player that is required; default "9"
        # * <tt>:size</tt> - the size of the Flash object, in the form "100x100".  Defaults to "100%x100%"
        # * <tt>:variables</tt> - a Hash of initialization variables that are passed to the object; (FlashVars)
        # * <tt>:parameters</tt> - a Hash of parameters that configure the display of the object; default <tt>{:parameters => {:wmode => "transparent"}}</tt>
        # * <tt>:express_install</tt> - If user don't had required flash version it will be instaled. To use this feature you need copy expressinstal.swf from assets plugin folder to your app public folder.
        #
        # Example:
        # * <tt>:<%= swfobject_tag "/swfs/header.swf", :div_id => "header_div", :express_install => "/swfs/expressinstall.swf" %></tt>

        def swfobject_tag source, options={}
          div_id = options[:div_id] || "flashcontent_#{rand(1_100)}"
          embed_id = options[:embed_id] || File.basename(source, '.swf') + "_#{rand(1_100)}"
          width, height = (options[:size]||'100%x100%').scan(/^(\d*%?)x(\d*%?)$/).first
          background_color = options[:background_color] || '#ffffff'
          flash_version = options[:flash_version] || 9
          variables = options.fetch(:variables, {})
          parameters = options.fetch(:parameters, {}) #{:scale => 'noscale'}
          express_install = options[:express_install] || nil
          express_install = "so.useExpressInstall('#{express_install}')" if express_install 
          return <<-"EOF"
          <script type="text/javascript">
          //<![CDATA[
            var so = new SWFObject("#{source}", "#{embed_id}", "#{width}", "#{height}", "#{flash_version}", "#{background_color}");
          	#{parameters.map{|k,v|%Q[so.addParam("#{k}", "#{v}");]}.join("\n")}
          	#{variables.map{|k,v|%Q[so.addVariable("#{k}", "#{v}");]}.join("\n")}
          	#{express_install}
          	so.write("#{div_id}");
          //]]>
          </script>
					EOF
        end
      end
    end
  end
end

ActionView::Base.class_eval do
  include ActionView::Helpers::SwfObjectHelper
end

#ActionView::Helpers::AssetTagHelper.register_javascript_include_default 'flashobject'