# $Id$

class SecurityQuestion < ActiveRecord::Base
  belongs_to :user

  validate :pair_exists
  
  def valid_answer?(answer_text)
    answer.downcase == answer_text.strip.downcase
  end
  
  protected
  
  def pair_exists
    if question.blank? || answer.blank?
      errors.add_to_base "Please enter a security question & answer pair"
    end
  end
end
