# $Id$

namespace :beta do
  desc "Send out invitation codes to interested users"
  task :send_invitation_codes => :environment do
    NotifyEmail.sent_at_nil.each do |email|
      @invitation = Invitation.new(:recipient_email => email.email)
      @invitation.sender = Member.first
      if @invitation.save
        UserMailer.deliver_invitation(@invitation, signup_url(@invitation.token, 'Free'))
        puts "Invite sent to #{email.email}"
        #email.update_attribute(:sent_at, Time.now)
      end
    end
  end
end