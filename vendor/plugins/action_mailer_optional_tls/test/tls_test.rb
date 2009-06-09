require File.dirname(__FILE__) + '/../../../../test/test_helper'
require "rubygems"
require 'test/unit'
require "actionmailer"
gem "actionpack"
#gem "actionmailer"
require File.dirname(__FILE__) + "/../init"

class Emailer < ActionMailer::Base
	def email(h)
		recipients h[:recipients]
		subject    h[:subject]
		from       h[:from]
		part :content_type => "text/plain", :body => h[:body]
	end
end

class TlsTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def setup

  end
  
  def test_send_mail
    #puts ActionMailer::Base.smtp_settings.inspect
    Emailer.deliver_email(
      :recipients => ENV["EMAIL"],
      :subject => "SMTP/TLS test",
      :from => ENV["EMAIL"],
      :body => "This email was sent at #{Time.now.inspect}"
    )
  end
end
