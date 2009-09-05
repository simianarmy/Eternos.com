# $Id$

def invite(sender, recipient)
  @invitation = Invitation.new(:recipient_email => recipient)
  @invitation.sender = sender
  if @invitation.save
    UserMailer.deliver_invitation(@invitation, signup_url(@invitation.token, 'Free', :host => AppConfig.base_domain))
    puts "Invite sent to #{recipient}"
  end
end

namespace :beta do
  desc "Send out invitation codes to interested users"
  task :send_invitation_codes => :environment do
    sender = Member.first
    NotifyEmail.sent_at_nil.each do |email|
      invite(sender, email.email)
    end
  end
  
  task :send_invitation => :environment do
    unless email = ENV['EMAIL']
      puts "Specify recipient email in EMAIL= arg"
      exit
    end
    invite(Member.first, email)
  end
  
  task :generate_code => :environment do
    require 'faker'
    [ENV['NUM'].to_i, 1].max.times do
      @invitation = Invitation.new(:recipient_email => Faker::Internet.email)
      @invitation.sender = Member.first
      if @invitation.save
        puts @invitation.token
      else
        puts @invitation.errors.full_messages
      end
    end
  end
end