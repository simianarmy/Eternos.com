namespace :notify do
  
  desc "Sends messages to fb users with fb's api"
  task :send => :environment do
    ids = FacebookId.all(:conditions => {:joined => false}, :select => 'facebook_uid').map{|obj| obj.facebook_uid.to_i}

    worker = Notificator::Spreader.new ids, Notificator::FbNotifyCanvas.new
    worker.notify
  end


  desc "Sends reports to users"
  task :report => :environment do
    worker = Notificator::Spreader.new Member.emailable.all, Notificator::ReportActor.new
    worker.notify
  end

end