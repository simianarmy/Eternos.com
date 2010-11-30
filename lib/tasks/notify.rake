namespace :notify do
  
  desc "Sends messages to fb users with fb's api"
  task :send => :environment do
    ids = FacebookId.all(:conditions => {:joined => false}, :select => 'facebook_uid').map{|obj| obj.facebook_uid.to_i}

    worker = Notificator::Spreader.new ids, Notificator::FbNotifyCanvas.new
    worker.notify
  end


  desc "Sends reports to users"
  task :report, [:period] => :environment do |t, args|
    users = Member.all(:conditions => {'id' => 17783}) #Member.emailable.all
    
    actor = Notificator::Report::Actor.new
    actor.period = args.period
    actor.logger = Notificator::Report::Logger.new
    
    worker = Notificator::Spreader.new users, actor
    worker.notify
  end

end