class AdminController < ApplicationController
  require_role "Admin"
end