# $Id$

# Members home page presenter

class MemberHomePresenter < Presenter
  attr_accessor :facebook_confirmed, :twitter_confirmed, :picasa_confirmed,
    :rss_confirmed, :gmail_confirmed
    
  include BackupSourceActivation
  
  def initialize(user)
    @user = user
    get_activations(@user)
  end
end