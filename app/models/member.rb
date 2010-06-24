# $Id$
class Member < User
  has_many :loved_ones, :through => :relationships, :source => :guest, :uniq => true
  has_many :invitations, :foreign_key => 'sender_id', :dependent => :destroy
  has_many :guest_invitations, :foreign_key => 'sender_id', :dependent => :destroy
  
  with_options :foreign_key => 'user_id' do |m|
    m.has_many :relationships, :class_name => 'GuestRelationship'
    m.has_many :trustees
    m.has_many :stories, :order => 'updated_at DESC'
    m.has_many :messages, :order => :start_at
    m.has_many :documentaries, :order => :start_at
    m.has_many :contents
    m.has_many :circles
    m.has_many :recordings
    m.has_many :backup_jobs
    m.has_many :backup_job_archives
    m.has_many :backup_sources
    m.has_many :backup_sites, :through => :backup_sources
    m.has_many :security_questions
    m.has_one :activity_stream
    m.has_one :backup_state
  end
  
  attr_accessible :security_question_attributes
  
  include ContentCollections::PhotoAlbum
  
  named_scope :needs_backup, lambda { |cutoff_date|
    {
    :include => :backup_state, # DO NOT use :joins - need LEFT JOIN, not INNER JOIN!
    :conditions => ['(backup_states.id IS NULL) OR ' +
      '((backup_states.last_backup_finished_at <= ?) OR ' +
      '(backup_states.last_failed_backup_at > backup_states.last_successful_backup_at))', 
      cutoff_date || Time.now.utc]
  } }
  named_scope :with_data, {
    :joins => :backup_state,
    :conditions => { 'backup_states.items_saved' => true }
  }
  named_scope :with_sources, {
    :joins => :backup_sources,
    :group => 'users.id'
  }
  
  def self.from_facebook(facebook_id)
    find_by_facebook_uid(facebook_id)
  end
  
  def backup_in_progress!
    (backup_state || build_backup_state).update_attribute(:in_progress, true)
  end
  
  def backup_in_progress?
    backup_state.in_progress rescue false
  end
  
  # Updates backup job tables with backup processes info
  def backup_finished!(info)
    bs = backup_state || build_backup_state
    bs.finished! info
    
    # Email member 1st time there is data for timeline
    if bs.first_time_data_available?
      # Send email in background
      spawn { BackupNotifier.deliver_timeline_ready(self) }
    end
  end
  
  def last_backup_job
    backup_jobs.recent.first
  end
  
  # Has this member setup their account yet?
  def need_backup_setup?
    backup_sources.active.empty?
  end
  
  # Returns all used categories
  def all_categories
    stories.map(&:category).delete_if {|c| c.nil?}.uniq
  end

  # Returns all member-created categories
  def categories
    stories.map(&:category).delete_if {|c| c.nil? or c.global}.uniq
  end

  # Returns all circles = (global + user's)
  def all_circles
    (circles + Circle.globals).uniq
  end
  
  # Adds relationship for guest
  def add_guest(guest, circle = guest.circle)    
    # Adds authorization plugin role: 'guest' of user
    # guests can identify their hosts with:
    #   guest.is_guest_of_what => Array of Members
    # and member can identify their guests with:
    #   member.has_guests? => true/false
    #   member.has_guests  => Array of Guests
    #
    # Things to watch out for:
    #  g.has_role? 'guest' => false
    #  g.has_role? 'guest, member => ArgumentError
    guest.is_guest_of self
    
    # Adds relationship: guest + circle
    relationships.create!(:guest => guest, :circle => circle)
  end
  
  def remove_guest(guest)
    relationships.find_by_guest_id(guest.id).destroy
  end
  
  def find_guests_by_relationship(circle_id)
    relationships.find_by_circle_id(circle_id)
  end
  
  def can?(action, item_type, item = nil)
    action != :destroy # Member can do anything but destroy items
  end
 
  def can_destroy_widget?(widget)
    true if widget.user == self # Oh, but he can destroy widgets that he owns
  end
  
  def member?
    true
  end
  
  def set_facebook_session_keys(session_key, secret_key='')
    self.facebook_session_key = session_key
    self.facebook_secret_key = secret_key
    save(false)
  end
  
  def authenticated_for_facebook_desktop?
    not (facebook_id.blank? || facebook_session_key.blank? || facebook_secret_key.blank?)
  end
  
  # Populates member profile info from facebook profile data structure
  # Returns success if both updates succeed
  def sync_with_facebook_profile(fb_user)
    fb_info = FacebookUserProfile.populate(fb_user)
    address_book.sync_with_facebook(fb_user, fb_info) && 
    profile.sync_with_facebook(fb_user, fb_info)
  end
  
  def has_backup_data?
    backup_state.items_saved rescue false
  end
  
  def timeline_span   
    # Look for earliest timeline event
    p = profile
    start_dates = [
      # TODO: Default timeline year span should be configurable 
      10.years.ago.to_date,
      address_book.birthdate, 
      p.birthday,
      (t = address_book.addresses.oldest) ? t.moved_in_on : nil,
      (t = p.families.oldest) ? t.birthdate : nil,
      (t = p.careers.oldest) ? t.start_at : nil,
      (t = p.schools.oldest) ? t.start_at : nil,
      (t = contents.ascend_by_taken_at.first) ? t.taken_at : nil,
      (t = contents.oldest) ? t.created_at : nil
      ]
    s = start_dates.compact.map(&:to_datetime).min
    [s.to_date, Date.today]
  end
  
  def completed_setup_step(step)
    self.increment!(:setup_step) if self.setup_step < step
  end
  
  def security_question_attributes=(attributes)
    attributes.each_pair do |idx, attr|
      security_questions[idx.to_i].update_attributes(attr)
    end
  end
   
  private
    
end
