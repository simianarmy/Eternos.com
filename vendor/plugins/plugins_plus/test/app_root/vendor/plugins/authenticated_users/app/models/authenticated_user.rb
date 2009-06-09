class AuthenticatedUser < ActiveRecord::Base
  cattr_accessor :loader
  self.loader = 'authenticated_users'
end
