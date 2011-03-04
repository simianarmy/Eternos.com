#:culerity or :selenium
Capybara.javascript_driver = :selenium
#:culerity or :selenium
Capybara.default_driver = :selenium

Capybara.run_server = true
Capybara.default_wait_time = 5 # seconds for slow ajax

#Capybara.app_host = "http://localhost:3001"
#Capybara.default_driver = :selenium
# Capybara.register_driver :selenium do |app|
#     Capybara::Driver::Selenium.new(app,
#       :browser => :local)
#       #:url => "http://192.168.1.127:4444/wd/hub",
#       #:desired_capabilities => :internet_explorer)
#   end
