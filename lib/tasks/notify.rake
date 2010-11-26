namespace :notify do
  
  desc "Sends messages to fb users with fb's api"
  task :send => :environment do
    ids = FacebookId.all(:conditions => {:joined => false}, :select => 'facebook_uid').map{|obj| obj.facebook_uid.to_i}

    worker = Notificator::Spreader.new ids, Notificator::FbPublisher.new
    worker.notify
  end
end