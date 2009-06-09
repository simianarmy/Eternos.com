require 'permissions'

class ContentAuthorization < ActiveRecord::Base
  belongs_to :authorizable, :polymorphic => true
  has_many :accessors, :class_name => 'ContentAccessor', :dependent => :destroy do
    def allowed_action(user, circle, action)
      find(:all, :conditions => find_conditions(user, circle, action))
    end

    def authorized(user, circle, action)
      with_scope(:find => { :conditions => find_conditions(user, circle, action) } ) do
        yield if block_given?
      end
    end
    
    def find_conditions(user, circle, action)
      user_id = user ? user.id : 0
      circle_id = circle ? circle.id : 0
      ['(user_id = 0 AND circle_id = 0 AND ((permissions & ?) > 0)) OR 
        (((user_id = ? AND circle_id = ?) OR (user_id = 0 AND circle_id = ?)) AND ((permissions & ?) > 0))', 
      action, user_id, circle_id, circle_id, action]
    end
  end
      
  AuthPublic    = 1
  AuthPrivate   = 2
  AuthPartial   = 3
  AuthInvisible = 4
  AuthDefault = AuthPrivate
  
  AuthorizationOptions    = {
    AuthPublic    => I18n.t('models.content_authorization.options.public.select_option'),
    AuthPrivate   => I18n.t('models.content_authorization.options.private.select_option'),
    AuthPartial   => I18n.t('models.content_authorization.options.partial.select_option'),
    AuthInvisible => I18n.t('models.content_authorization.options.invisible.select_option')
  }
  
  def self.select_options
    AuthorizationOptions.invert
  end
  
  def invisible?
    privacy_level == AuthInvisible
  end
  
  def all_private?
    privacy_level == AuthPrivate
  end
  
  def all_public?
    privacy_level == AuthPublic
  end
  
  def partial?
    privacy_level == AuthPartial
  end
  
  # Helpers for authorizations association extensions
  
  # Returns array of content accessor objects matching criteria
  def is_authorized_for(user, group=nil, action=Permissions::View)
    invisible? ? [] : accessors.allowed_action(user, group, action)
  end
  
  # Returns true/false depending on authorization levels
  def is_authorized_for?(user, group=nil, action=Permissions::View)
    case
    when invisible?
      false
    when all_public?
      true
    when all_private?
      if !authorizable
        false
      elsif user and user.get_host(authorizable.get_owner.id)
        true
      elsif group
        group.owner == authorizable.get_owner
      else
        false
      end
    else
      not is_authorized_for(user, group, action).empty?
    end
  end
end
