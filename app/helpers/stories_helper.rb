# $Id$
module StoriesHelper
  def show_story_photo(story)
    image_tag(story.photo.url(:small), :class => 'thumbnail') if story.has_photo?
  end
end
