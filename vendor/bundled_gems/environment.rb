# DO NOT MODIFY THIS FILE
module Bundler
 file = File.expand_path(__FILE__)
 dir = File.dirname(file)

  ENV["GEM_HOME"] = dir
  ENV["GEM_PATH"] = dir
  ENV["PATH"]     = "#{dir}/bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{file} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.16/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-2.0.16/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-ssh-gateway-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/ext/json/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/contacts-1.0.18/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/contacts-1.0.18/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/searchlogic-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/searchlogic-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json_pure-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/SystemTimer-1.1.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/SystemTimer-1.1.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rake-0.8.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-scp-1.0.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/newrelic_rpm-2.9.8/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/newrelic_rpm-2.9.8/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/lockfile-1.4.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/lockfile-1.4.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rio-0.4.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rio-0.4.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/right_http_connection-1.2.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/right_http_connection-1.2.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/taf2-curb-0.5.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/taf2-curb-0.5.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/taf2-curb-0.5.4.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/tzinfo-0.3.15/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/tzinfo-0.3.15/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/net-sftp-2.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/columnize-0.3.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/columnize-0.3.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/linecache-0.43/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/linecache-0.43/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/shared-mime-info-0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/shared-mime-info-0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hpricot-0.8.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hpricot-0.8.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/eventmachine-0.12.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/eventmachine-0.12.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mysqlplus-0.1.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mysqlplus-0.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mash-0.1.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mash-0.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hirb-0.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hirb-0.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/jnunemaker-columbus-0.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/jnunemaker-columbus-0.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/term-ansicolor-1.0.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/term-ansicolor-1.0.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rubyforge-2.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.3.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hoe-2.3.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/image_science-1.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/image_science-1.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/simianarmy-facebooker-1.0.51/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/simianarmy-facebooker-1.0.51/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/oyster-0.9.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/oyster-0.9.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/packr-3.1.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/packr-3.1.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/polyglot-0.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/polyglot-0.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/treetop-1.4.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/treetop-1.4.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/nokogiri-1.4.0/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mdalessio-dryopteris-0.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mdalessio-dryopteris-0.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mime-types-1.16/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/mime-types-1.16/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/pauldix-sax-machine-0.0.14/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/pauldix-sax-machine-0.0.14/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/tmm1-amqp-0.6.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/tmm1-amqp-0.6.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.6.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/bundler-0.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/builder-2.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/diff-lcs-1.1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/right_aws-1.10.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/right_aws-1.10.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/xml-simple-1.0.12/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/xml-simple-1.0.12/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/aws-s3-0.6.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/aws-s3-0.6.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/moomerman-twitter_oauth-0.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/moomerman-twitter_oauth-0.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ezcrypto-0.7.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ezcrypto-0.7.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.15/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/haml-2.2.15/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/active_presenter-1.2.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/active_presenter-1.2.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/crack-0.1.4/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/crack-0.1.4/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/chronic-0.2.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/javan-whenever-0.3.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/javan-whenever-0.3.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rvideo-0.9.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rvideo-0.9.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/memcache-client-1.7.7/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/memcache-client-1.7.7/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rack-1.0.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/webrat-0.6.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/webrat-0.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-hmac-0.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-hmac-0.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-ext-1.2.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionmailer-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionmailer-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/highline-1.5.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.10/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/capistrano-2.5.10/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-base-0.10.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-base-0.10.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-0.10.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/ruby-debug-0.10.3/cli")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activesupport-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activerecord-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activerecord-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/markevans-block_helpers-0.2.11/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/markevans-block_helpers-0.2.11/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/pauldix-feedzirra-0.0.18/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/pauldix-feedzirra-0.0.18/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionpack-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/actionpack-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/oauth-0.3.6/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/oauth-0.3.6/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activeresource-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/activeresource-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rails-2.3.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rails-2.3.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/cucumber-0.4.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/cucumber-0.4.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-1.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-rails-1.2.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/rspec-rails-1.2.9/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hashie-0.1.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/hashie-0.1.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/httparty-0.4.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/httparty-0.4.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/twitter-0.7.9/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/twitter-0.7.9/lib")

  @gemfile = "#{dir}/../../Gemfile"

  require "rubygems"

  @bundled_specs = {}
  @bundled_specs["net-ssh"] = eval(File.read("#{dir}/specifications/net-ssh-2.0.16.gemspec"))
  @bundled_specs["net-ssh"].loaded_from = "#{dir}/specifications/net-ssh-2.0.16.gemspec"
  @bundled_specs["net-ssh-gateway"] = eval(File.read("#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"))
  @bundled_specs["net-ssh-gateway"].loaded_from = "#{dir}/specifications/net-ssh-gateway-1.0.1.gemspec"
  @bundled_specs["json"] = eval(File.read("#{dir}/specifications/json-1.2.0.gemspec"))
  @bundled_specs["json"].loaded_from = "#{dir}/specifications/json-1.2.0.gemspec"
  @bundled_specs["contacts"] = eval(File.read("#{dir}/specifications/contacts-1.0.18.gemspec"))
  @bundled_specs["contacts"].loaded_from = "#{dir}/specifications/contacts-1.0.18.gemspec"
  @bundled_specs["searchlogic"] = eval(File.read("#{dir}/specifications/searchlogic-2.3.2.gemspec"))
  @bundled_specs["searchlogic"].loaded_from = "#{dir}/specifications/searchlogic-2.3.2.gemspec"
  @bundled_specs["json_pure"] = eval(File.read("#{dir}/specifications/json_pure-1.2.0.gemspec"))
  @bundled_specs["json_pure"].loaded_from = "#{dir}/specifications/json_pure-1.2.0.gemspec"
  @bundled_specs["SystemTimer"] = eval(File.read("#{dir}/specifications/SystemTimer-1.1.3.gemspec"))
  @bundled_specs["SystemTimer"].loaded_from = "#{dir}/specifications/SystemTimer-1.1.3.gemspec"
  @bundled_specs["rake"] = eval(File.read("#{dir}/specifications/rake-0.8.7.gemspec"))
  @bundled_specs["rake"].loaded_from = "#{dir}/specifications/rake-0.8.7.gemspec"
  @bundled_specs["net-scp"] = eval(File.read("#{dir}/specifications/net-scp-1.0.2.gemspec"))
  @bundled_specs["net-scp"].loaded_from = "#{dir}/specifications/net-scp-1.0.2.gemspec"
  @bundled_specs["newrelic_rpm"] = eval(File.read("#{dir}/specifications/newrelic_rpm-2.9.8.gemspec"))
  @bundled_specs["newrelic_rpm"].loaded_from = "#{dir}/specifications/newrelic_rpm-2.9.8.gemspec"
  @bundled_specs["lockfile"] = eval(File.read("#{dir}/specifications/lockfile-1.4.3.gemspec"))
  @bundled_specs["lockfile"].loaded_from = "#{dir}/specifications/lockfile-1.4.3.gemspec"
  @bundled_specs["rio"] = eval(File.read("#{dir}/specifications/rio-0.4.2.gemspec"))
  @bundled_specs["rio"].loaded_from = "#{dir}/specifications/rio-0.4.2.gemspec"
  @bundled_specs["right_http_connection"] = eval(File.read("#{dir}/specifications/right_http_connection-1.2.4.gemspec"))
  @bundled_specs["right_http_connection"].loaded_from = "#{dir}/specifications/right_http_connection-1.2.4.gemspec"
  @bundled_specs["taf2-curb"] = eval(File.read("#{dir}/specifications/taf2-curb-0.5.4.0.gemspec"))
  @bundled_specs["taf2-curb"].loaded_from = "#{dir}/specifications/taf2-curb-0.5.4.0.gemspec"
  @bundled_specs["tzinfo"] = eval(File.read("#{dir}/specifications/tzinfo-0.3.15.gemspec"))
  @bundled_specs["tzinfo"].loaded_from = "#{dir}/specifications/tzinfo-0.3.15.gemspec"
  @bundled_specs["net-sftp"] = eval(File.read("#{dir}/specifications/net-sftp-2.0.4.gemspec"))
  @bundled_specs["net-sftp"].loaded_from = "#{dir}/specifications/net-sftp-2.0.4.gemspec"
  @bundled_specs["columnize"] = eval(File.read("#{dir}/specifications/columnize-0.3.1.gemspec"))
  @bundled_specs["columnize"].loaded_from = "#{dir}/specifications/columnize-0.3.1.gemspec"
  @bundled_specs["linecache"] = eval(File.read("#{dir}/specifications/linecache-0.43.gemspec"))
  @bundled_specs["linecache"].loaded_from = "#{dir}/specifications/linecache-0.43.gemspec"
  @bundled_specs["shared-mime-info"] = eval(File.read("#{dir}/specifications/shared-mime-info-0.1.gemspec"))
  @bundled_specs["shared-mime-info"].loaded_from = "#{dir}/specifications/shared-mime-info-0.1.gemspec"
  @bundled_specs["hpricot"] = eval(File.read("#{dir}/specifications/hpricot-0.8.2.gemspec"))
  @bundled_specs["hpricot"].loaded_from = "#{dir}/specifications/hpricot-0.8.2.gemspec"
  @bundled_specs["eventmachine"] = eval(File.read("#{dir}/specifications/eventmachine-0.12.10.gemspec"))
  @bundled_specs["eventmachine"].loaded_from = "#{dir}/specifications/eventmachine-0.12.10.gemspec"
  @bundled_specs["mysqlplus"] = eval(File.read("#{dir}/specifications/mysqlplus-0.1.1.gemspec"))
  @bundled_specs["mysqlplus"].loaded_from = "#{dir}/specifications/mysqlplus-0.1.1.gemspec"
  @bundled_specs["mash"] = eval(File.read("#{dir}/specifications/mash-0.1.1.gemspec"))
  @bundled_specs["mash"].loaded_from = "#{dir}/specifications/mash-0.1.1.gemspec"
  @bundled_specs["hirb"] = eval(File.read("#{dir}/specifications/hirb-0.2.9.gemspec"))
  @bundled_specs["hirb"].loaded_from = "#{dir}/specifications/hirb-0.2.9.gemspec"
  @bundled_specs["jnunemaker-columbus"] = eval(File.read("#{dir}/specifications/jnunemaker-columbus-0.1.2.gemspec"))
  @bundled_specs["jnunemaker-columbus"].loaded_from = "#{dir}/specifications/jnunemaker-columbus-0.1.2.gemspec"
  @bundled_specs["term-ansicolor"] = eval(File.read("#{dir}/specifications/term-ansicolor-1.0.4.gemspec"))
  @bundled_specs["term-ansicolor"].loaded_from = "#{dir}/specifications/term-ansicolor-1.0.4.gemspec"
  @bundled_specs["rubyforge"] = eval(File.read("#{dir}/specifications/rubyforge-2.0.3.gemspec"))
  @bundled_specs["rubyforge"].loaded_from = "#{dir}/specifications/rubyforge-2.0.3.gemspec"
  @bundled_specs["hoe"] = eval(File.read("#{dir}/specifications/hoe-2.3.3.gemspec"))
  @bundled_specs["hoe"].loaded_from = "#{dir}/specifications/hoe-2.3.3.gemspec"
  @bundled_specs["image_science"] = eval(File.read("#{dir}/specifications/image_science-1.2.1.gemspec"))
  @bundled_specs["image_science"].loaded_from = "#{dir}/specifications/image_science-1.2.1.gemspec"
  @bundled_specs["simianarmy-facebooker"] = eval(File.read("#{dir}/specifications/simianarmy-facebooker-1.0.51.gemspec"))
  @bundled_specs["simianarmy-facebooker"].loaded_from = "#{dir}/specifications/simianarmy-facebooker-1.0.51.gemspec"
  @bundled_specs["oyster"] = eval(File.read("#{dir}/specifications/oyster-0.9.3.gemspec"))
  @bundled_specs["oyster"].loaded_from = "#{dir}/specifications/oyster-0.9.3.gemspec"
  @bundled_specs["packr"] = eval(File.read("#{dir}/specifications/packr-3.1.0.gemspec"))
  @bundled_specs["packr"].loaded_from = "#{dir}/specifications/packr-3.1.0.gemspec"
  @bundled_specs["polyglot"] = eval(File.read("#{dir}/specifications/polyglot-0.2.9.gemspec"))
  @bundled_specs["polyglot"].loaded_from = "#{dir}/specifications/polyglot-0.2.9.gemspec"
  @bundled_specs["treetop"] = eval(File.read("#{dir}/specifications/treetop-1.4.2.gemspec"))
  @bundled_specs["treetop"].loaded_from = "#{dir}/specifications/treetop-1.4.2.gemspec"
  @bundled_specs["nokogiri"] = eval(File.read("#{dir}/specifications/nokogiri-1.4.0.gemspec"))
  @bundled_specs["nokogiri"].loaded_from = "#{dir}/specifications/nokogiri-1.4.0.gemspec"
  @bundled_specs["mdalessio-dryopteris"] = eval(File.read("#{dir}/specifications/mdalessio-dryopteris-0.1.2.gemspec"))
  @bundled_specs["mdalessio-dryopteris"].loaded_from = "#{dir}/specifications/mdalessio-dryopteris-0.1.2.gemspec"
  @bundled_specs["mime-types"] = eval(File.read("#{dir}/specifications/mime-types-1.16.gemspec"))
  @bundled_specs["mime-types"].loaded_from = "#{dir}/specifications/mime-types-1.16.gemspec"
  @bundled_specs["pauldix-sax-machine"] = eval(File.read("#{dir}/specifications/pauldix-sax-machine-0.0.14.gemspec"))
  @bundled_specs["pauldix-sax-machine"].loaded_from = "#{dir}/specifications/pauldix-sax-machine-0.0.14.gemspec"
  @bundled_specs["tmm1-amqp"] = eval(File.read("#{dir}/specifications/tmm1-amqp-0.6.4.gemspec"))
  @bundled_specs["tmm1-amqp"].loaded_from = "#{dir}/specifications/tmm1-amqp-0.6.4.gemspec"
  @bundled_specs["bundler"] = eval(File.read("#{dir}/specifications/bundler-0.6.0.gemspec"))
  @bundled_specs["bundler"].loaded_from = "#{dir}/specifications/bundler-0.6.0.gemspec"
  @bundled_specs["builder"] = eval(File.read("#{dir}/specifications/builder-2.1.2.gemspec"))
  @bundled_specs["builder"].loaded_from = "#{dir}/specifications/builder-2.1.2.gemspec"
  @bundled_specs["diff-lcs"] = eval(File.read("#{dir}/specifications/diff-lcs-1.1.2.gemspec"))
  @bundled_specs["diff-lcs"].loaded_from = "#{dir}/specifications/diff-lcs-1.1.2.gemspec"
  @bundled_specs["right_aws"] = eval(File.read("#{dir}/specifications/right_aws-1.10.0.gemspec"))
  @bundled_specs["right_aws"].loaded_from = "#{dir}/specifications/right_aws-1.10.0.gemspec"
  @bundled_specs["xml-simple"] = eval(File.read("#{dir}/specifications/xml-simple-1.0.12.gemspec"))
  @bundled_specs["xml-simple"].loaded_from = "#{dir}/specifications/xml-simple-1.0.12.gemspec"
  @bundled_specs["aws-s3"] = eval(File.read("#{dir}/specifications/aws-s3-0.6.2.gemspec"))
  @bundled_specs["aws-s3"].loaded_from = "#{dir}/specifications/aws-s3-0.6.2.gemspec"
  @bundled_specs["moomerman-twitter_oauth"] = eval(File.read("#{dir}/specifications/moomerman-twitter_oauth-0.2.1.gemspec"))
  @bundled_specs["moomerman-twitter_oauth"].loaded_from = "#{dir}/specifications/moomerman-twitter_oauth-0.2.1.gemspec"
  @bundled_specs["ezcrypto"] = eval(File.read("#{dir}/specifications/ezcrypto-0.7.2.gemspec"))
  @bundled_specs["ezcrypto"].loaded_from = "#{dir}/specifications/ezcrypto-0.7.2.gemspec"
  @bundled_specs["haml"] = eval(File.read("#{dir}/specifications/haml-2.2.15.gemspec"))
  @bundled_specs["haml"].loaded_from = "#{dir}/specifications/haml-2.2.15.gemspec"
  @bundled_specs["active_presenter"] = eval(File.read("#{dir}/specifications/active_presenter-1.2.0.gemspec"))
  @bundled_specs["active_presenter"].loaded_from = "#{dir}/specifications/active_presenter-1.2.0.gemspec"
  @bundled_specs["crack"] = eval(File.read("#{dir}/specifications/crack-0.1.4.gemspec"))
  @bundled_specs["crack"].loaded_from = "#{dir}/specifications/crack-0.1.4.gemspec"
  @bundled_specs["chronic"] = eval(File.read("#{dir}/specifications/chronic-0.2.3.gemspec"))
  @bundled_specs["chronic"].loaded_from = "#{dir}/specifications/chronic-0.2.3.gemspec"
  @bundled_specs["javan-whenever"] = eval(File.read("#{dir}/specifications/javan-whenever-0.3.7.gemspec"))
  @bundled_specs["javan-whenever"].loaded_from = "#{dir}/specifications/javan-whenever-0.3.7.gemspec"
  @bundled_specs["rvideo"] = eval(File.read("#{dir}/specifications/rvideo-0.9.3.gemspec"))
  @bundled_specs["rvideo"].loaded_from = "#{dir}/specifications/rvideo-0.9.3.gemspec"
  @bundled_specs["memcache-client"] = eval(File.read("#{dir}/specifications/memcache-client-1.7.7.gemspec"))
  @bundled_specs["memcache-client"].loaded_from = "#{dir}/specifications/memcache-client-1.7.7.gemspec"
  @bundled_specs["rack"] = eval(File.read("#{dir}/specifications/rack-1.0.1.gemspec"))
  @bundled_specs["rack"].loaded_from = "#{dir}/specifications/rack-1.0.1.gemspec"
  @bundled_specs["webrat"] = eval(File.read("#{dir}/specifications/webrat-0.6.0.gemspec"))
  @bundled_specs["webrat"].loaded_from = "#{dir}/specifications/webrat-0.6.0.gemspec"
  @bundled_specs["ruby-hmac"] = eval(File.read("#{dir}/specifications/ruby-hmac-0.3.2.gemspec"))
  @bundled_specs["ruby-hmac"].loaded_from = "#{dir}/specifications/ruby-hmac-0.3.2.gemspec"
  @bundled_specs["capistrano-ext"] = eval(File.read("#{dir}/specifications/capistrano-ext-1.2.1.gemspec"))
  @bundled_specs["capistrano-ext"].loaded_from = "#{dir}/specifications/capistrano-ext-1.2.1.gemspec"
  @bundled_specs["actionmailer"] = eval(File.read("#{dir}/specifications/actionmailer-2.3.2.gemspec"))
  @bundled_specs["actionmailer"].loaded_from = "#{dir}/specifications/actionmailer-2.3.2.gemspec"
  @bundled_specs["highline"] = eval(File.read("#{dir}/specifications/highline-1.5.1.gemspec"))
  @bundled_specs["highline"].loaded_from = "#{dir}/specifications/highline-1.5.1.gemspec"
  @bundled_specs["capistrano"] = eval(File.read("#{dir}/specifications/capistrano-2.5.10.gemspec"))
  @bundled_specs["capistrano"].loaded_from = "#{dir}/specifications/capistrano-2.5.10.gemspec"
  @bundled_specs["ruby-debug-base"] = eval(File.read("#{dir}/specifications/ruby-debug-base-0.10.3.gemspec"))
  @bundled_specs["ruby-debug-base"].loaded_from = "#{dir}/specifications/ruby-debug-base-0.10.3.gemspec"
  @bundled_specs["ruby-debug"] = eval(File.read("#{dir}/specifications/ruby-debug-0.10.3.gemspec"))
  @bundled_specs["ruby-debug"].loaded_from = "#{dir}/specifications/ruby-debug-0.10.3.gemspec"
  @bundled_specs["activesupport"] = eval(File.read("#{dir}/specifications/activesupport-2.3.2.gemspec"))
  @bundled_specs["activesupport"].loaded_from = "#{dir}/specifications/activesupport-2.3.2.gemspec"
  @bundled_specs["activerecord"] = eval(File.read("#{dir}/specifications/activerecord-2.3.2.gemspec"))
  @bundled_specs["activerecord"].loaded_from = "#{dir}/specifications/activerecord-2.3.2.gemspec"
  @bundled_specs["markevans-block_helpers"] = eval(File.read("#{dir}/specifications/markevans-block_helpers-0.2.11.gemspec"))
  @bundled_specs["markevans-block_helpers"].loaded_from = "#{dir}/specifications/markevans-block_helpers-0.2.11.gemspec"
  @bundled_specs["pauldix-feedzirra"] = eval(File.read("#{dir}/specifications/pauldix-feedzirra-0.0.18.gemspec"))
  @bundled_specs["pauldix-feedzirra"].loaded_from = "#{dir}/specifications/pauldix-feedzirra-0.0.18.gemspec"
  @bundled_specs["actionpack"] = eval(File.read("#{dir}/specifications/actionpack-2.3.2.gemspec"))
  @bundled_specs["actionpack"].loaded_from = "#{dir}/specifications/actionpack-2.3.2.gemspec"
  @bundled_specs["oauth"] = eval(File.read("#{dir}/specifications/oauth-0.3.6.gemspec"))
  @bundled_specs["oauth"].loaded_from = "#{dir}/specifications/oauth-0.3.6.gemspec"
  @bundled_specs["activeresource"] = eval(File.read("#{dir}/specifications/activeresource-2.3.2.gemspec"))
  @bundled_specs["activeresource"].loaded_from = "#{dir}/specifications/activeresource-2.3.2.gemspec"
  @bundled_specs["rails"] = eval(File.read("#{dir}/specifications/rails-2.3.2.gemspec"))
  @bundled_specs["rails"].loaded_from = "#{dir}/specifications/rails-2.3.2.gemspec"
  @bundled_specs["cucumber"] = eval(File.read("#{dir}/specifications/cucumber-0.4.3.gemspec"))
  @bundled_specs["cucumber"].loaded_from = "#{dir}/specifications/cucumber-0.4.3.gemspec"
  @bundled_specs["rspec"] = eval(File.read("#{dir}/specifications/rspec-1.2.9.gemspec"))
  @bundled_specs["rspec"].loaded_from = "#{dir}/specifications/rspec-1.2.9.gemspec"
  @bundled_specs["rspec-rails"] = eval(File.read("#{dir}/specifications/rspec-rails-1.2.9.gemspec"))
  @bundled_specs["rspec-rails"].loaded_from = "#{dir}/specifications/rspec-rails-1.2.9.gemspec"
  @bundled_specs["hashie"] = eval(File.read("#{dir}/specifications/hashie-0.1.5.gemspec"))
  @bundled_specs["hashie"].loaded_from = "#{dir}/specifications/hashie-0.1.5.gemspec"
  @bundled_specs["httparty"] = eval(File.read("#{dir}/specifications/httparty-0.4.5.gemspec"))
  @bundled_specs["httparty"].loaded_from = "#{dir}/specifications/httparty-0.4.5.gemspec"
  @bundled_specs["twitter"] = eval(File.read("#{dir}/specifications/twitter-0.7.9.gemspec"))
  @bundled_specs["twitter"].loaded_from = "#{dir}/specifications/twitter-0.7.9.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env && env.to_s ; end
      def method_missing(*) ; yield if block_given? ; end
      def only(*env)
        old, @only = @only, _combine_only(env.flatten)
        yield
        @only = old
      end
      def except(*env)
        old, @except = @except, _combine_except(env.flatten)
        yield
        @except = old
      end
      def gem(name, *args)
        opt = args.last.is_a?(Hash) ? args.pop : {}
        only = _combine_only(opt[:only] || opt["only"])
        except = _combine_except(opt[:except] || opt["except"])
        files = opt[:require_as] || opt["require_as"] || name
        files = [files] unless files.respond_to?(:each)

        return unless !only || only.any? {|e| e == @env }
        return if except && except.any? {|e| e == @env }

        if files = opt[:require_as] || opt["require_as"]
          files = Array(files)
          files.each { |f| require f }
        else
          begin
            require name
          rescue LoadError
            # Do nothing
          end
        end
        yield if block_given?
        true
      end
      private
      def _combine_only(only)
        return @only unless only
        only = [only].flatten.compact.uniq.map { |o| o.to_s }
        only &= @only if @only
        only
      end
      def _combine_except(except)
        return @except unless except
        except = [except].flatten.compact.uniq.map { |o| o.to_s }
        except |= @except if @except
        except
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile), @gemfile, 1)
  end
end

module Gem
  @loaded_stacks = Hash.new { |h,k| h[k] = [] }

  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
