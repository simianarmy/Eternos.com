# $Id$
class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  belongs_to :user
  
  scope_out :tagged_with, :conditions => [],
    :joins => "JOIN tags ON tags.id = taggings.tag_id",
    :group => "tag_id", 
    :order => 'tags.name'
    
  # Allows searching by partial name
  def self.search(query, search_options={}, sql_options={})
    return [] if query.blank?
    conds = EZ::Where::Condition.new :tag do
      name =~ '%' + query.downcase + '%'
    end
    conds.append search_options if search_options.any?
    sql_options[:conditions] = conds.to_sql
    find_tagged_with :all, sql_options
  end
  
  def before_destroy
    # disallow orphaned tags
    tag.destroy_without_callbacks if tag.taggings.count < 2  
  end
  
end
