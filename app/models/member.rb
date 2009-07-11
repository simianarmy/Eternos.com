# $Id$
class Member < User
  has_many :loved_ones, :through => :relationships, :source => :guest, :uniq => true
  has_many :invitations, :foreign_key => 'sender_id', :dependent => :destroy
  has_many :guest_invitations, :foreign_key => 'sender_id', :dependent => :destroy
 
  with_options :dependent => :destroy, :foreign_key => 'user_id' do |m|
    m.has_many :relationships
    m.has_many :stories, :order => 'updated_at DESC'
    m.has_many :messages, :order => :start_at
    m.has_many :documentaries, :order => :start_at
    m.has_many :contents, :order => 'contents.updated_at DESC'
    m.has_many :circles
    m.has_many :recordings
    m.has_many :backup_jobs
    m.has_many :backup_job_archives
    m.has_many :backup_sources
    m.has_many :backup_sites, :through => :backup_sources
    m.has_one :activity_stream
    m.has_one :backup_state
    m.has_one :profile
  end

  after_create :create_associations_and_activate
  
  # Scoped finders
  named_scope :with_backup_targets,
    :joins => :backup_sources, 
    :conditions => { :backup_sources => { :auth_confirmed => true } }
  
  named_scope :needs_backup, lambda { |cutoff_date|
    {
    :include => [:backup_state],
    :conditions => ['(backup_states.id IS NULL) OR (backup_states.in_progress = ? AND backup_states.last_backup_finished_at <= ?)', 
      false, cutoff_date]
  } }
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    spawn do
      SubscriptionNotifier.deliver_password_reset(self)
    end
  end
  
  def backup_in_progress!
    (backup_state || build_backup_state).update_attribute(:in_progress, true)
  end
  
  # Updates backup tables with backup process info
  
  def backup_finished!(info)
    (backup_state || build_backup_state).finished! info
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
  
  # temporary function to get member lifespan beginning-end
  def lifespan_beginning_and_end
    "#{20.years.ago.to_date}/#{DateTime.now.to_date.to_s}/"
  end
  
  private
    
  def create_associations_and_activate
    activate!
    create_activity_stream
    create_profile
  end
end
