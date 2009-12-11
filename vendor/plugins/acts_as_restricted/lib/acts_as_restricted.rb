# $Id$
# ActsAsRestricted

module Eternos
  module Acts
    module Restricted
      def self.included(base)
        base.extend ClassMethods
      end
  
      module ClassMethods
        def acts_as_restricted(options={})
          has_one :privacy_setting, :class_name => 'ContentAuthorization', :as => :authorizable, 
            :dependent => :destroy

          delegate :is_authorized_for, :to => "get_privacy_setting"
          delegate :is_authorized_for?, :to => "get_privacy_setting"
          
          if options[:owner_method]
            define_method(:get_owner, Proc.new { self.send(options[:owner_method]) } )
          else
            raise ArgumentError, "acts_as_restricted must include 'owner_method' option"
          end
          
          include Eternos::Acts::Restricted::InstanceMethods
          extend Eternos::Acts::Restricted::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
         # Returns all objects allowed for user and/or group with specified action
        def authorized_for(user, group=nil, action=Permissions::View)
          ContentAuthorization.find_authorized(user, group, action) do
            find(:all, :include => :authorizations)
          end
        end
      end
      
      module InstanceMethods
        # Default privacy_setting fetcher, if one not yet built, so we always have an object
        # to work with
       
        def get_privacy_setting
          # Way to use find_or_initialize on association?
          @privacy_setting ||= privacy_setting || build_privacy_setting(:privacy_level => ContentAuthorization::AuthDefault)
        end
        
        # Returns authorization or (default) level
        def authorization
          get_privacy_setting.privacy_level
        end
        
        # Returns accessors objects
        def authorizations
          get_privacy_setting.accessors
        end
        
        # Shortcuts to is_authorized_for? methods
        def authorized_for_user?(user)
          is_authorized_for?(user, user.circle)
        end
        
        def authorized_for_group?(group)
          is_authorized_for?(nil, group)
        end
        
        # Sets authorization of object for a user and group
        # Side effect changes authorization level to 'partial'
        def authorize_for_user(user, group=nil, actions=Permissions::View)
          # Must save content authorization association 1st
          get_privacy_setting.save
          auth = authorizations.find_or_initialize_by_user_id_and_circle_id(
            :user_id => user ? user.id : 0, 
            :circle_id => group ? group.id : 0)
          auth.permissions = Permissions.new(actions)
          if auth.save
            update_privacy_level(ContentAuthorization::AuthPartial)
          end
        end
        
        # Adds authorization of object for a group
        def authorize_for_group(group, actions=Permissions::View)
          authorize_for_user(nil, group, actions)
        end
        
        # Sets up authorization for anyone (rare)
        def authorize_for_all
          # Clear all authorizations and create an allow-all entry
          ContentAuthorization.transaction do
            update_privacy_level(ContentAuthorization::AuthPublic)
            clear_accessors
          end
        end
        
        # Sets up authorization for all invited guests
        def authorize_for_all_guests
          # Clear all authorizations and create an allow-all entry
          #ContentAuthorization.transaction do
            update_privacy_level(ContentAuthorization::AuthPrivate)
            clear_accessors
          #end
        end
          
        # Sets up authorization for nobody (buy owner)
        def authorize_for_none
          # Clear all authorizations and create an allow-all entry
          ContentAuthorization.transaction do
            update_privacy_level(ContentAuthorization::AuthInvisible)
            clear_accessors
          end
        end
        
        # Returns authorization options for form select
        def authorization_select_options
          ContentAuthorization.select_options
        end
        
        # For assignment from form
        def privacy_settings=(attributes)
          attr = attributes.symbolize_keys
          if !attr[:authorization].blank?
            case attr[:authorization].to_i
            when ContentAuthorization::AuthPublic
              authorize_for_all
            when ContentAuthorization::AuthPrivate
              authorize_for_all_guests
            when ContentAuthorization::AuthInvisible
              authorize_for_none
            else
              update_privacy_level(attr[:authorization].to_i)
              update_accessors_from_attributes(attr)
            end
         end
        end
        
        private
        
        # helper to remove all accessors
        def clear_accessors
          get_privacy_setting.accessors.clear
        end
        
        # Helper for form assignments - sets accessors (users & groups)
        def update_accessors_from_attributes(attributes)
          if attributes[:guests]
            # Clear existing accessors and add selected ones
            clear_accessors
            attributes[:guests].each do |guest_id|
              if g = Guest.find(guest_id.to_i)
                authorize_for_user(g, g.current_circle)
              end
            end
          end
          if attributes[:circles]
            attributes[:circles].each do |circle_id|
              if c = Circle.find(circle_id.to_i)
                authorize_for_group(c)
              end
            end
          end
        end
        
        def update_privacy_level(level)
          get_privacy_setting.update_attribute(:privacy_level, level)
        end
      end
    end
  end
end


    