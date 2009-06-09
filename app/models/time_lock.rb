# $Id$
#
# TimeLock STI class

class TimeLock < ActiveRecord::Base
  belongs_to :lockable, :polymorphic => true
  
  validates_existence_of :lockable, :on => :update
  validate :validate_unlock_date, :if => Proc.new {|rec| rec.type != "DeathLock"}
  
  @@NoLock        = 0
  @@UnlockOnDate  = 1
  @@UnlockOnDeath = 2
  
  class << self
    def default; unlocked end
    def unlocked; @@NoLock end
    def date_locked; @@UnlockOnDate end
    def death_locked; @@UnlockOnDeath end
    def select_options
      { @@NoLock => I18n.t('models.time_lock.none.select_option'),
        @@UnlockOnDate => I18n.t('models.time_lock.dated.select_option'),
        @@UnlockOnDeath => I18n.t('models.death_lock.select_option') }.invert
    end
  end
  
  def expired?
    unlock_on.nil? || (unlock_on <= Date.today)
  end
  
  protected
  
  def validate_unlock_date
    if !unlock_on
      errors.add_to_base "Please select a date in the future for {lockable}"
    elsif unlock_on <= Date.today
      errors.add_to_base "{lockable} date must be in the future"
    end
  end
end

class DeathLock < TimeLock
  def validate_unlock_date; end
  
  def expired?
    false
  end
end






