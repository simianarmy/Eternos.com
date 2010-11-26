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
  
  def fb_comment
    stub('FacebookBackup::FacebookComment', 
      :xid => '123',
      :fromid => 111,
      :time => Time.now.to_i,
      :text => Faker::Lorem.sentence,
      :id => '112',
      :user_data => {
        :username => 'bob',
        :user_pic => Faker::Internet.domain_name,
        :profile_url => Faker::Internet.domain_name
      }
      )
  end
  
  def create_facebooker_page
    stub('Facebooker::Page', 
      :page_id => rand(100).to_s,
      :name => Faker::Lorem.words(1),
      :page_url => Faker::Internet.domain_name,
      :location => 'somewhere'
      )
  end
end