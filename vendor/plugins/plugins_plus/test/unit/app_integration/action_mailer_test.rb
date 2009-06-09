require File.expand_path("#{File.dirname(__FILE__)}/../../test_helper")

module AppIntegration
class ActionMailerTest < Test::Unit::TestCase
  def test_should_include_plugin_template_paths_in_template_path
    # Need to use allocate since initialize won't give us the instance
    mailer = UserNotifications.allocate
    
    expected = [
      "#{Rails.root}/app/views",      "#{Rails.root}/vendor/plugins/plugin_with_templates/app/views",      "#{Rails.root}/vendor/plugins/authenticated_users/app/views",      "#{Rails.root}/vendor/plugins/users/app/views"    ].collect {|path| "#{path}/user_notifications"}
    
    assert_equal "{#{expected * ','}}", mailer.send(:template_path)
  end
end
end
