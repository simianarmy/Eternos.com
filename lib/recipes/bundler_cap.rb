# $Id$

# Bundler recipes

set :bundler_path, "vendor/bundled_gems"

namespace :bundler do
  task :install do
    sudo "gem bundle"
  end

  task :symlink_vendor do
    bundler_path = fetch(:bundler_path)
    shared_gems = File.join(shared_path, bundler_path)
    release_gems = "#{release_path}/#{bundler_path}"
    %w(cache gems specifications).each do |sub_dir|
      shared_sub_dir = File.join(shared_gems, sub_dir)
      run("mkdir -p #{shared_sub_dir} && mkdir -p #{release_gems} && ln -s #{shared_sub_dir} #{release_gems}/#{sub_dir}")
    end
  end

  task :bundle_new_release do
    bundler.symlink_vendor
    run("cd #{release_path} && gem bundle --only #{stage}")
  end
end

after 'deploy:update_code', 'bundler:bundle_new_release'