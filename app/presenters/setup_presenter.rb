# $Id$

# Presenter class for account_setup & account_settings controller views
# Contains common methods for both controllers

class SetupPresenter < Presenter
  @@NumSecurityQuestions = 2
  
  attr_accessor :address_book, :profile, :new_address_book, :new_profile, :security_questions,
    :active_step, :completed_steps, 
    :facebook_account, :facebook_confirmed, :facebook_user, :facebook_pic, :fb_login_url,
    :twitter_accounts, :twitter_account, :twitter_confirmed,
    :feed_urls, :feed_url, :rss_url, :rss_confirmed,
    :email_accounts, :current_gmail, :gmail_confirmed,
    :errors, :params
  
  def initialize(user, fb_session, params)
    @user = user
    @fb_session = fb_session
    @params = params
  end
  
  def address_book
    @address_book ||= @user.address_book
  end
  
  def profile
    @profile ||= @user.profile
  end
  
  def security_questions
    @security_questions ||= @user.security_questions
  end
  
  def load_personal_info
    @address_book = address_book
    @profile  = profile
    @security_questions = security_questions
    (0..@@NumSecurityQuestions-1).each do |i|
      @security_questions[i] ||= @user.security_questions.new
    end
  end
  
  def update_personal_info
    @new_address_book = params[:address_book]
    @new_profile = params[:profile]
    @errors = []
    
    unless @profile.update_attributes(@new_profile)
      @errors = @profile.errors.full_messages
    end
    unless @address_book.update_attributes(@new_address_book)
      @errors = @address_book.errors.full_messages
    end
    # Save security questions
    @user.update_attributes(params[:user])
    unless @user.security_questions.all?(&:valid?)
      @errors = @user.security_questions.collect(&:errors).map(&:full_messages).uniq
    end
    @errors.empty?
  end
   
  def has_required_personal_info_fields?
     (ab = @address_book) &&
     !ab.first_name.blank? && !ab.last_name.blank? && ab.birthdate &&
     (@user.security_questions.size == @@NumSecurityQuestions)
  end
   
  def create_fb_login_url(request)
    # Desktop login url 
    # Using url described on http://wiki.developers.facebook.com/index.php/Authorization_and_Authentication_for_Desktop_Applications#Prompting_for_Permissions
    @fb_login_url = @fb_session.login_url_with_perms(
      :next => authorized_facebook_backup_url(:host => request.host), 
      :next_cancel => cancel_facebook_backup_url(:host => request.host)
      )
  end
  
  def load_backup_sources
    backup_sources = @user.backup_sources
    if backup_sources.any?
      if @facebook_account = backup_sources.facebook.first
        if @facebook_confirmed = @facebook_account.confirmed?
          begin
            @user.facebook_session_connect @fb_session
            @fb_session.user.populate(:pic_small, :name) if @fb_session.verify
            @facebook_user = @fb_session.user.name
            @facebook_pic = @fb_session.user.pic_small
          rescue Facebooker::Session::SessionExpired
            # What to do ??
          end
        end
      else
        @facebook_confirmed = false
      end
      @twitter_accounts = backup_sources.twitter.paginate :page => params[:page], :per_page => 10
      @twitter_account   = backup_sources.twitter.first
      @twitter_confirmed = @twitter_accounts && @twitter_accounts.any? {|t| t.confirmed?}
      @feed_urls = backup_sources.blog.paginate :page => params[:page], :per_page => 10
      @feed_url = FeedUrl.new
      @rss_confirmed = @feed_urls && @feed_urls.any? {|t| t.confirmed?}
      @email_accounts = @user.backup_sources.gmail.paginate :page => params[:page], :per_page => 10
      @current_gmail = @email_accounts.first
      @gmail_confirmed = @email_accounts && @email_accounts.any? {|t| t.confirmed?}
    end
  end
end
  
