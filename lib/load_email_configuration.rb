# $Id$
if RAILS_ENV != 'test'
  c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  ActionMailer::Base.smtp_settings = {
    :address => c[RAILS_ENV]['server'],
    :port => c[RAILS_ENV]['port'],
    :domain => c[RAILS_ENV]['domain'],
    :authentication => c[RAILS_ENV]['authentication'],
    :user_name => c[RAILS_ENV]['username'],
    :password => c[RAILS_ENV]['password'],
    :tls => c[RAILS_ENV]['tls']
  } unless c[RAILS_ENV].nil?
end
