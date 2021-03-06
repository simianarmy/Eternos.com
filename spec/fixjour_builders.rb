# $Id$

# Fixjour builder defs
require 'faker'
require RAILS_ROOT + '/spec/content_spec_helper'
include ContentSpecHelper

#Fixjour :verify => true do
Fixjour  do
  define_builder(Account) do |klass, overrides|
    klass.protected :full_domain
    
    klass.new(
      :plan => new_subscription_plan,
      :user => overrides[:user] || new_member,
      :name => 'My first account',
      :full_domain => 'test.host')
  end
  
  define_builder(ActivityStream) do |klass, overrides|
    klass.new(
      :member => new_member)
  end
  
  define_builder(ActivityStreamItem) do |klass, overrides|
    klass.protected :type
    
    overrides.process(:type) do |type|
      overrides[:type] = nil
      klass = type.constantize
    end
    
    klass.new(
      :activity_stream => new_activity_stream)
  end
  
  define_builder(Address) do |klass, overrides|
    klass.protected :addressable
    
    klass.new(
      :location_type => Address::DefaultLocationType,
      :street_1 => Faker::Address.street_address,
      :city => Faker::Address.city,
      :country_id => 4, # Afghanistan!
      :postal_code => Faker::Address.zip_code,
      :moved_in_on => Date.today - rand(100)
      )
  end
  
  define_builder(AddressBook) do |klass, overrides|
    klass.protected :user
    
    klass.new(
      :name_title => Faker::Name.prefix,
      :first_name => Faker::Name.first_name, 
      :middle_name => Faker::Name.first_name,
      :last_name => Faker::Name.last_name,
      :name_suffix => Faker::Name.suffix,
      :website => Faker::Internet.domain_name,
      :birthdate => 20.years.ago,
      :address_attributes => valid_address_attributes,
      :new_phone_number_attributes => [valid_phone_number_attributes],
      :user => new_user)
  end
  
  define_builder(BackupEmail) do |klass, overrides|
    klass.new(:backup_source => new_backup_source,
      :message_id => Faker::Lorem.words(3).join(':'),
      :mailbox => 'inbox',
      :subject => Faker::Lorem.sentence)
  end
  
  define_builder(BackupJob) do |klass, overrides|
    klass.new(:size => rand(1000) * 1.kilobyte,
        :status => 'ok',
        :percent_complete => 100,
        :member => new_member)
  end
  
  define_builder(BackupPhoto) do |klass, overrides|
    klass.new(:backup_photo_album => new_backup_photo_album,
      :source_photo_id => 100,
      :source_url => 'http://www.jpg',
      :caption => Faker::Lorem.sentence,
      :tags => Faker::Lorem.words(3))
  end
  
  define_builder(BackupPhotoAlbum) do |klass, overrides|
    klass.new(:backup_source => new_backup_source,
      :source_album_id => 1000,
      :name => Faker::Lorem.sentence,
      :modified => Time.now.to_i.to_s)
  end
  
  define_builder(BackupSite) do |klass, overrides|
    klass.new(:name => 'facebook')
  end
  
  define_builder(BackupSource) do |klass, overrides|
    klass.new(
      :auth_login => Faker::Internet.user_name,
      :auth_password => Faker::Lorem.words(1).first,
      :auth_confirmed => true,
      :member => new_member,
      :backup_site => new_backup_site)
  end
  
  define_builder(BackupSourceJob) do |klass, overrides|
    klass.protected :backup_source, :backup_job
    klass.new(
      :backup_source => new_backup_source,
      :backup_job => new_backup_job)
  end
  
  define_builder(BackupState) do |klass, overrides|
    klass.new(:member => new_member)
  end
  
  define_builder(Category) do |klass, overrides|
     klass.new(:name => 'global', :global => 1)
   end
   
  define_builder(Circle) do |klass, overrides|
    klass.new(:name => Faker::Lorem.words(1).first, :user_id => 0)
  end
  
  define_builder(Comment) do |klass, overrides|
    klass.new(:title => Faker::Lorem.sentence, :comment => Faker::Lorem.sentence)
  end
  
  define_builder(Content) do |klass, overrides|
    overrides.process(:type) do |type|
      overrides[:data] = case type
      when :photo
        image_file
      when :audio, :music
        audio_file
      when :web_video
        web_video_file
      when :video
        video_file
      else
        text_file
      end
    end
    
    @obj = klass.factory(
      :title => overrides[:title] || 'media',
      :uploaded_data => overrides[:data] || text_file, 
      :taken_at => 1.year.ago,
      :owner => overrides[:owner] || new_member)
  end
  
  define_builder(FacebookAccount) do |klass, overrides|
    obj = klass.new
    obj.type = 'FacebookAccount'
    obj
  end
  
  define_builder(FacebookContent) do |klass, overrides|
    klass.new(
      :profile => new_profile, 
      :friends => Faker::Lorem.paragraph)
  end
  
  define_builder(FacebookPage) do |klass, overrides|
    klass.new(
      :page_id => rand % 1000,
      :name => Faker::Name.name,
      :url => Faker::Internet.domain
    )
  end
  
  define_builder(Family) do |klass, overrides|
    klass.new(
      :profile => new_profile,
      :name => Faker::Name.name,
      :family_type => new_circle,
      :birthdate => Date.today
    )
  end
  
  define_builder(Element) do |klass, overrides|
    klass.new(
      :story => new_story,
      :title => Faker::Lorem.sentence, 
      :message => Faker::Lorem.paragraph,
      :tag_s => Faker::Lorem.words.join(','))
  end
  
  define_builder(Feed) do |klass, overrides|
    klass.new(
      :feed_url => new_feed_url,
      :title => Faker::Name.first_name)
  end
  
  define_builder(FeedContent) do |klass, overrides|
    klass.new(
      :feed_entry => new_feed_entry
      )
  end
  
  define_builder(FeedEntry) do |klass, overrides|
    klass.new(
      :feed => new_feed,
      :name => Faker::Name.first_name,
      :summary => Faker::Lorem.sentence,
      :published_at => Time.now,
      :guid => Faker::Lorem.words(3).join(':'))
  end
  
  define_builder(FeedUrl) do |klass, overrides|
    klass.new(
      :rss_url => 'http://simian187.vox.com',
      :member => new_member,
      :backup_site => new_backup_site(:name => 'blog'))
  end

  define_builder(Guest) do |klass, overrides|
    klass.protected :circle_id
    
    klass.new(
      :first_name => Faker::Name.first_name,
      :last_name => Faker::Name.last_name,
      :email => Faker::Internet.email,
      :circle_id => 0)
  end
  
  define_builder(GuestInvitation) do |klass, overrides|
    klass.protected :sender, :circle
    klass.new(
      :sender => overrides[:sender] || new_member,
      :circle => new_circle,
      :email => Faker::Internet.email,
      :name => Faker::Name.name,
      :contact_method => 'email')
  end
  
  define_builder(Job) do |klass, overrides|
    start_date = Date.today - rand(100)
    klass.new(
      :profile => new_profile,
      :company => Faker::Name.name + ', Inc.',
      :title => Faker::Lorem.sentence,
      :start_at => start_date,
      :end_at => start_date + rand(100)
      )
  end
  
  define_builder(MedicalCondition) do |klass, overrides|
    klass.new(
      :profile => new_profile,
      :name => Faker::Lorem.sentence,
      :diagnosis_date => Date.today - rand(100)
    )
  end
  
  define_builder(Member) do |klass, overrides|
    passwords = {:password => 'shoe1str1ng', :password_confirmation => 'shoe1str1ng'}
    overrides.process(:password) do |pwd|
      if !pwd.blank?
        passwords[:password] = passwords[:password_confirmation] = pwd
      end
    end
        
    klass.new(valid_user_attributes(overrides).merge(passwords))
  end
  
  define_builder(Message) do |klass, overrides|
    klass.new(
      :member => new_member,
      :title => Faker::Lorem.sentence,
      :message => Faker::Lorem.paragraph,
      :tag_s => Faker::Lorem.words.join(','))
  end
  
  define_builder(PhoneNumber) do |klass, overrides|
    klass.new(
      :phone_type => PhoneNumber::DefaultPhoneType,
      :area_code => "206",
      :number => Faker.numerify('###-####'))
  end
    
  define_builder(Profile) do |klass, overrides|
    klass.new(
      :member => new_member)
  end
  
  define_builder(Recording) do |klass, overrides|
    overrides.process(:type) do |type|
      overrides[:filename] = "audiorecording.flv" if type == :audio
    end
    klass.new(
      :member => new_member, 
      :filename => "video_recording.flv", 
      :state => "pending")
  end
  
  define_builder(School) do |klass, overrides|
    klass.new(
      :profile => new_profile,
      :name => Faker::Name.name,
      :start_at => Date.today-rand(100),
      :end_at => Date.today-rand(50)
    )
  end
  
  define_builder(Story) do |klass, overrides|
    klass.new(
      :member => new_member, 
      :title => Faker::Lorem.sentence,
      :story => Faker::Lorem.sentence, 
      :category => new_category, 
      :tag_list => Faker::Lorem.words.join(','))
  end
  
  define_builder(Subscription) do |klass, overrides|
    klass.new(
      :account => new_account,
      :subscription_plan => new_subscription_plan(:type => :basic),
      :user_limit => 3,
      :next_renewal_at => 1.day.ago.to_s(:db),
      :amount => 10,
      :card_number => 'XXXX-XXXX-XXXX-1111',
      :card_expiration => '05-2012',
      :billing_id => 'foo'
    )
  end
  
  define_builder(SubscriptionPlan) do |klass, overrides|
    overrides.process(:type) do |tp|
      if tp == :basic
        overrides[:amount] = 10
        overrides[:name] = 'Basic'
        overrides[:user_limit] = 3
      elsif tp == :advanced
        overrides[:amount] = 10
        overrides[:name] = 'Advanced'
        overrides[:user_limit] = 10
      end
    end
    
    klass.new(
      :amount => 0,
      :name => 'Free',
      :user_limit => 1,
      :allow_subdomain => false)
  end
  
  define_builder(TimeLock) do |klass, overrides|
    klass.protected :lockable
    
    type = TimeLock.date_locked
    overrides.process(:type) do |tp|
      type = TimeLock.death_locked if tp == :death_lock
    end
    klass.new(
      :lockable => overrides[:lockable],
      :type => type,
      :unlock_on => 1.day.from_now)
  end
  
  define_builder(Trustee) do |klass, overrides|
    klass.new(:user => new_member,
      :name => Faker::Lorem.first_name,
      :relationship => 'brother',
      :emails => [Faker::Internet.email],
      :security_question => Faker::Lorem.sentence,
      :security_answer => Faker::Lorem.sentence
    )
  end
  
  define_builder(User) do |klass, overrides|
    klass.protected :facebook_uid, :invitation_limit, :state
    
    passwords = {:password => 'shoe1str1ng', :password_confirmation => 'shoe1str1ng'}
    fb_id = nil
    
    overrides.process(:password) do |pwd|
      passwords[:password] = passwords[:password_confirmation] = pwd
    end
    overrides.process(:facebook) do |fb|
      passwords[:password] = passwords[:password_confirmation] = nil
      fb_id = fb
    end
    
    klass.new(
      :email => Faker::Internet.email,
      :first_name => Faker::Name.first_name,
      :last_name => Faker::Name.last_name,
      :password => passwords[:password],
      :password_confirmation => passwords[:password_confirmation],
      :facebook_uid => fb_id
      )
  end  
end
