namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Category, Story].each(&:delete_all)
    
    Category.populate 20 do |category|
      category.name = Populator.words(1..3).titleize
      category.user_id = 26
      Story.populate 10..100 do |story|
        story.user_id = category.user_id
        story.title = Populator.words(1..5).titleize
        story.description = Populator.sentences(2..10)
        story.created_at = 2.years.ago..Time.now
      end
    end
    
#    Person.populate 100 do |person|
#      person.name    = Faker::Name.name
#      person.company = Faker::Company.name
#      person.email   = Faker::Internet.email
#      person.phone   = Faker::PhoneNumber.phone_number
#      person.street  = Faker::Address.street_address
#      person.city    = Faker::Address.city
#      person.state   = Faker::Address.us_state_abbr
#      person.zip     = Faker::Address.zip_code
#    end
  end
  
  desc "Populates from sql dump"
  task :load_sql => :environment do
    datadir = "#{RAILS_ROOT}/db/dataset"
    raise "Need source file: file=<source>" unless ENV['file']
    
    file = if File.exist?(ENV['file'])
      ENV['file']
    elsif File.exist?(path=File.join(datadir, ENV['file']))
      path
    else
      puts "file not found"
      exit
    end
    sql = File.open(file).read
    sql.split(';').each do |sql_statement|
      ActiveRecord::Base.connection.execute(sql_statement)
    end
    puts "SQL loaded at #{Time.now}"
  end
    
  desc "Fill required database records"
  task :populate_required => :bootstrap_saas do
    puts "Populating categories"
    Category.delete_all('global = 1')
    Category.create(:name=>"Birth", :global => 1)
    Category.create(:name=>"Marriage", :global => 1)
    Category.create(:name=>"Children", :global => 1)
    Category.create(:name=>"Education", :global => 1)
    Category.create(:name=>"Career", :global => 1)
    
    puts "Populating relationships"
    Circle.delete_all('user_id = 0')
    Circle.create(:name => 'Spouse', :user_id => 0)
    Circle.create(:name => "Child", :user_id => 0)
    Circle.create(:name => "Parent", :user_id => 0)
    Circle.create(:name => "Friend", :user_id => 0)
    Circle.create(:name => "Sibling", :user_id => 0)
    
    puts "Populating backup sites"
    BackupSite.delete_all
    BackupSite.create(:name => 'facebook')
    BackupSite.create(:name => 'twitter')
    BackupSite.create(:name => 'gmail')
    BackupSite.create(:name => 'flickr')
    BackupSite.create(:name => 'blog')
  end

  desc "Fill subscription related tables"
  task :bootstrap_saas => :environment do
    #Rake::Task["db:schema:load"].invoke
    puts "Populating Saas tables"
    SubscriptionPlan.delete_all
    plans = [
      { 'name' => 'Free', 'amount' => 0, 'user_limit' => 2 },
      { 'name' => 'Basic', 'amount' => 10, 'user_limit' => 5 },
      { 'name' => 'Premium', 'amount' => 30, 'user_limit' => nil }
    ].collect do |plan|
      SubscriptionPlan.create(plan)
    end
    user = User.new(:name => 'Test', :login => 'test', :password => 'test', :password_confirmation => 'test', :email => 'test@example.com')
    a = Account.create(:name => 'Test Account', :domain => 'localhost', :plan => plans.first, :user => user)
    a.update_attribute(:full_domain, 'localhost')
  end
end