require File.expand_path("#{File.dirname(__FILE__)}/../test_helper")

class MailNotificationsTest < Test::Unit::TestCase
  def test_should_use_app_template_if_only_in_app
    mail = UserNotifications.create_signup_notification
    assert_equal "App SignupNotification\n", mail.body
  end
  
  def test_should_use_app_template_if_in_app_and_plugin
    mail = UserNotifications.create_message_alert
    assert_equal "App MessageAlert\n", mail.body
  end
  
  def test_should_use_plugin_template_if_not_in_app
    mail = UserNotifications.create_username_reminder
    assert_equal "Users UsernameReminder\n", mail.body
  end
  
  def test_should_use_last_loaded_plugin_template_if_in_multiple_plugins
    mail = UserNotifications.create_password_reminder
    assert_equal "AuthenticatedUsers PasswordReminder\n", mail.body
  end
  
  def test_should_use_app_template_if_in_app_and_template_name_is_part_of_directory
    mail = UserNotifications.create_user_notifications_information
    assert_equal "App UserNotificationsInformation\n", mail.body
  end
end
