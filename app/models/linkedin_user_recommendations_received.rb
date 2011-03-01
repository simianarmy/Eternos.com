class LinkedinUserRecommendationsReceived < ActiveRecord::Base
  belongs_to :linkedin_user,:foreign_key => "linkedin_user_id"

   def self.process_hash(recommendations_received)
    if (recommendations_received.nil?)
      return nil
    end
    recommendations_received['linkedin_id']  = recommendations_received['recommender'].delete('id')
    recommendations_received['last_name'] = recommendations_received['recommender'].delete('last_name')
    recommendations_received['first_name'] = recommendations_received['recommender'].delete('first_name')
    recommendations_received.delete('recommender')
    recommendations_received['recommendation_type'] = recommendations_received['recommendation_type'].delete('code')
    recommendations_received.delete('recommendation_type')

    return recommendations_received
  end

  def self.from_recommendations_receiveds(recommendations_received)
    if recommendations_received.nil?
      return nil
    end
    recommendations_received = self.process_hash(recommendations_received)
    li = self.new(recommendations_received)
    li
  end
  def self.delete(user_id)
    self.delete_all(["linkedin_user_id = ?" , user_id])

  end
end
