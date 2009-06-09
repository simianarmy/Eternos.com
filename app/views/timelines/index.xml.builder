xml.instruct! :xml, :version => "1.0" 
xml.stories do
  for @story in @stories
    xml.title @story.title
    xml.description @story.description
    xml.pubDate @story.created_at.to_s(:rfc822)
  end
end