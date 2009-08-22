module AuthlogicFacebookConnect
  module Helper
    def authlogic_facebook_login_button(options = {})
      options[:controller] ||= "user_sessions"
      options[:protocol] ||= 'https'
      
      output = form_tag({:controller => options[:controller], :protocol => options[:protocol], :only_path => false}, 
        :id => 'connect_fo_facebook_form') + '</form>'
      output += javascript_tag "function connect_to_facebook() {
        // Remove all other forms to prevent bug that sends their values along with this one's
        $('connect_fo_facebook_form').submit();
      }"     
      output += fb_login_button("connect_to_facebook()", :size => :medium, :background => :white, 
        :length => :long)
    end
  end
end