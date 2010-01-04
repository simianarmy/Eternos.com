# $Id$

module FacebookSpecHelper
  def create_facebook_user
    stub('FacebookUser', 
      :work_history => [work_history_object],
      :education_history => [education_object]
      )
  end
  
  def work_history_object
    stub('Facebooker::WorkInfo', 
      :start_date => '2001-01-01', 
      :end_date => nil,
      :company_name => 'company', 
      :position => 'job position',
      :description => 'job description',
      :location => stub('Location'))
  end
  
  def education_object
    stub('Facebooker::EducationHistory')
  end
end