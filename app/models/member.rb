# $Id$
class Member < User
  has_many :loved_ones, :through => :relationships, :source => :guest, :uniq => true
  has_many :invitations, :foreign_key => 'sender_id', :dependent => :destroy
  has_many :guest_invitations, :foreign_key => 'sender_id', :dependent => :destroy
 
  with_options :foreign_key => 'user_id' do |m|
    m.has_many :relationships
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
    m.has_one :profile
  end
  
  attr_accessible :security_question_attributes
  
  named_scope :needs_backup, lambda { |cutoff_date|
    {
    :joins => :backup_state,
    :conditions => ['(backup_states.id IS NULL) OR (backup_states.in_progress = ? AND ' +
      '((backup_states.last_backup_finished_at <= ?) OR ' +
      '(backup_states.last_failed_backup_at > backup_states.last_successful_backup_at)))', 
      false, cutoff_date || Time.now]
  } }
  named_scope :with_data, {
    :joins => :backup_state,
    :conditions => { 'backup_states.items_saved' => true }
  }
  
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    spawn do
      SubscriptionNotifier.deliver_password_reset(self)
    end
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
    
  def has_backup_data?
    backup_state.items_saved rescue false
  end
  
  def timeline_span   
    # Look for earliest timeline event
    p = profile
    start = [
      10.years.ago.to_date,
      address_book.birthdate, 
      (t = address_book.addresses.oldest) ? t.moved_in_on : nil,
      (t = p.families.oldest) ? t.birthdate : nil,
      (t = p.careers.oldest) ? t.start_at : nil,
      (t = p.schools.oldest) ? t.start_at : nil,
      (t = contents.ascend_by_taken_at.first) ? t.taken_at : nil,
      (t = contents.oldest) ? t.created_at : nil
      ].compact.min
    [start.to_date, Date.today]
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
