class LinkedinPeopleRecommendationsReceiveds < ActiveRecord::Base
   belongs_to :linkedin_people,:foreign_key => "linkedin_people_id"

  def self.from_recommendations_receiveds(recommendations_received)
  if recommendations_received.nil?
	return nil
  end
    recommendations_received['linkedin_id']  = recommendations_received['recommender'].delete('id')
    recommendations_received['last_name'] = recommendations_received['recommender'].delete('last_name')
    recommendations_received['first_name'] = recommendations_received['recommender'].delete('first_name')
    recommendations_received.delete('recommender')
    recommendations_received['recommendation_type'] = recommendations_received['recommendation_type'].delete('code')
    recommendations_received.delete('recommendation_type')
    li = self.new(recommendations_received)
    li
  end
end
