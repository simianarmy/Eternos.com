# $Id$

# Presenter class for Vault backup setup 

class Vault::BackupPresenter < SetupPresenter
  # Simply skipping session instance
  def initialize(user, params)
    super(user, nil, params)
  end
  
end