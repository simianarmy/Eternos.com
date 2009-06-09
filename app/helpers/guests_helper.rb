module GuestsHelper
  # Displays guest invitation's status as human readable string
  def invitation_status_text(guest)
    if guest.created?
      'Processing'
    elsif guest.pending?
      'Delivering invitation'
    elsif guest.waiting?
      'Invitation sent'
    elsif guest.dormant?
      'Pending delivery date'
    elsif guest.support_processing?
      'Attempting to contact'
    else
      'Accepted'
    end
  end
end
