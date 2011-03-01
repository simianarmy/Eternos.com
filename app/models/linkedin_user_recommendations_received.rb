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
  def self.update_recommendations_receiveds(recommendations_received,user_id)
    if recommendations_received.nil?
      return nil
    end

    recommendations_received = self.process_hash(recommendations_received)
    li = self.find_all_by_recommendation_id_and_linkedin_user_id(recommendations_received['recommendation_id'],user_id).first
    li.update_attributes(recommendations_received)
    li.save
  end
end
