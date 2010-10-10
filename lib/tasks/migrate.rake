# $Id$

namespace :db do
  namespace :auto do
    desc "Runs auto_migrate & prepares test db"
    task :migrate do
      if Rails.env == 'development'
        puts "cloning to test db"
        Rake::Task["db:test:prepare"].invoke
      end
    end
  end
end