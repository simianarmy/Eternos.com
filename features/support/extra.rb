# Make sure this require is after you require cucumber/rails/world.
require 'email_spec' # add this line if you use spork
require 'email_spec/cucumber'
require 'fixjour'
require 'faker'

Before do
  DatabaseCleaner.clean
  Vault::AccountsController.any_instance.stub(:verify_recaptcha).returns(true)
end