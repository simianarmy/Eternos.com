class AdminsController < ApplicationController
  require_role "Admin"
end