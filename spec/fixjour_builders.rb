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
      :name => 'shit head',
      :full_domain => 'test.host')
  end
  
  define_builder(ActivityStream) do |klass, overrides|
    klass.new(
      :member => new_member,
      :backup_site => new_backup_site)
  end
  
  define_builder(ActivityStreamItem) do |klass, overrides|
    klass.new(
      :activity_stream => new_activity_stream)
  end
  
  define_builder(Address) do |klass, overrides|
    klass.protected :addressable
    
    klass.new(
      :location_type => Address::DefaultLocationType,
      :street_1 => Faker::Address.street_address,
      :street_2 => Faker::Address.street_address,
      :city => Faker::Address.city,
      :country_id => 4, # Afghanistan!
      :postal_code => Faker::Address.zip_code)
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
  
  define_builder(BackupSourceDay) do |klass, overrides|
    klass.new(:backup_source => new_backup_source,
      :backup_day => Date.today - rand(365),
      :status_id => BackupStatus::Success,
      :in_progress => false,
      :skip => false)
  end
  
  define_builder(Category) do |klass, overrides|
     klass.new(:name => 'global', :global => 1)
   end
   
  define_builder(Circle) do |klass, overrides|
    klass.new(:name => Faker::Lorem.words(1).first, :user_id => 0)
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
  
  define_builder(FacebookActivityStreamItem) do |klass, overrides|
    klass.new(
      :activity_stream => new_activity_stream)
  end
  
  define_builder(FacebookContent) do |klass, overrides|
    klass.new(
      :profile => new_profile, 
      :friends => Faker::Lorem.paragraph)
  end
  
  define_builder(Element) do |klass, overrides|
    klass.new(
      :story => new_story,
      :title => Faker::Lorem.sentence, 
      :message => Faker::Lorem.paragraph,
      :tag_s => Faker::Lorem.words.join(','))
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
  
  define_builder(Story) do |klass, overrides|
    klass.new(
      :member => new_member, 
      :title => Faker::Lorem.sentence,
      :story => Faker::Lorem.sentence, 
      :category => new_category, 
      :tag_s => Faker::Lorem.words.join(','))
  end
  
  define_builder(SubscriptionPlan) do |klass, overrides|
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
