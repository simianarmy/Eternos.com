namespace :notify do
  
  desc "Sends messages to fb users with fb's api"
  task :send => :environment do
    ids = FacebookId.all(:conditions => {:joined => false}, :select => 'facebook_uid').map{|obj| obj.facebook_uid.to_i}

    worker = Notificator::Spreader.new ids, Notificator::FbNotifyCanvas.new
    worker.notify
  end


  desc "Sends reports to users"
  task :report, [:period] => :environment do |t, args|
    default_period = 'weekly'
    args.with_defaults(:period => default_period)
    users = Member.
            emailable.
            unupdated_since(args.period == default_period ? (Time.now.to_date - 6) : ((Time.now.to_date << 1) + 1)).
            reportable(args.period).
            all(:readonly => false)

    actor = Notificator::Report::Actor.new
    actor.period = args.period
    actor.logger = Notificator::Report::Logger.new
    
    worker = Notificator::Spreader.new users, actor
    worker.notify
  end

end