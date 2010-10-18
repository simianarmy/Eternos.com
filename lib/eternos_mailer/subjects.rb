module EternosMailer
  # Contains mailer subject constants and lookup helper methods
  module Subjects
    # Constant hash of mail subject symbol => subject strings
    # Including classes use this for setting the mailer subject.
    # Access strings via the subject() method
    @@Subjects = {
      :signup_notification    => 'Activate Your Eternos.com Account',
      :activation             => 'Your account has been activated!',
      :invitation             => 'Invitation From Eternos.com',
      :inactive_notification  => 'Inactive Account Notice',
      :account_setup_reminder => 'Complete your Eternos.com Account Setup',
      :friend_invitation      => 'Invitation to Eternos.com',
      :timeline_ready         => 'Your Eternos Timeline is ready!',
      :backup_errors          => 'Problems archiving your data'
    }
  
  
    # Lookup email subject string by title (ideally title = mailer action)
    def subject_from_sym(action)
      @@Subjects[action.to_sym]
    end
  end
end