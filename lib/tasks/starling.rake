namespace :starling do
  desc "Start starling"
  task :start do
    system "starling -d -P #{RAILS_ROOT}/tmp/pids/starling.pid -q #{RAILS_ROOT}/tmp/starling"
  end
end