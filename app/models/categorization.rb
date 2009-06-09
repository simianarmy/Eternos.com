# $Id$
class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :categorizable, :polymorphic => true
  
  before_create :remove_duplicates
  
  private
  # Solves problem with has_many_polymorphs where creating story would cause 
  # categorization to be added random # times in same transaction, causing a lot 
  # of duplicate records.  I could not determine the cause of the random repeated 
  # inserts, so got this from
  # http://blog.evanweaver.com/articles/2006/09/11/make-polymorphic-children-belong-to-only-one-parent/
  # which destroys duplicate before inserting again .
  #
  # I could not repeat this in tests, only in development...
  def remove_duplicates
    logger.debug "Categorization: before_create: Removing categorization duplications"
    if record = Categorization.find(:first,
      :conditions => ["categorizable_id = ? AND categorizable_type = ?",
        categorizable_id, categorizable_type])
      logger.debug "Removing duplicate: #{record.category.name}"
      record.destroy
    end
    true
  end
end
