# $Id$
# Various facebook-backup related modules

module FacebookerSpecHelper
  def new_facebooker_album
    Facebooker::Album.new(:aid => "100", :size=> 2, :link => 'link_url', :cover_pid => '10', 
    :name => 'test album', :modified => '1244850471', :aid => '100', :populated => true, 
    :location => 'nowwhere')
  end

  def new_facebooker_photo
    Facebooker::Photo.new(:aid => "100", :pid => rand(Time.now), 
    :caption => Faker::Lorem.sentence, :populated => true,
    :src_big => "http://#{Faker::Internet.domain_name}/pic.jpg", :tags => Faker::Lorem.words,
    :created => Time.now)
  end
  
  # Helper to create instance of a Facebooker::Comment object
  def new_facebooker_comment
    Facebooker::Comment.new(:fromid => rand.to_s, :object_id => rand.to_s, :text => Faker::Lorem.words(3), 
      :time => Time.now.to_i, :post_id => gen_post_id)
  end
  
  def gen_post_id
    [rand.to_s, rand.to_s].join('_')
  end
  
end

module FacebookProxyObjectSpecHelper
  def new_album(album=new_facebooker_album)
    FacebookProxyObjects::FacebookPhotoAlbum.new(album)
  end

  def new_photo(photo=new_facebooker_photo)
    FacebookProxyObjects::FacebookPhoto.new(photo)
  end
  
  def new_proxy_fb_comment(comm)
    FacebookProxyObjects::FacebookObjectComment.new(comm)
  end
end


# ActivityStreamProxySpecHelper Module
#
# Methods for mocking the ActivityStreamProxy classes

module ActivityStreamProxySpecHelper
  include FacebookProxyObjectSpecHelper
  
  def create_stream_proxy_item
    item = ActivityStreamProxy.new
    item.updated = item.created = Time.now.to_i
    item.message = 'blah blah'
    item.activity_type = 'status'
    item.attachment = nil
    item
  end

  # Only facebook supported right now
  def create_stream_proxy_item_with_attachment(type)
    item = ActivityStreamProxy.new
    item.updated = item.created = Time.now.to_i
    item.message = 'blah blah'
    item.attachment_type = type
    item.activity_type = 'post'
    item
  end

  def create_facebook_stream_proxy_item_with_attachment(type)
    item = create_stream_proxy_item_with_attachment(type)
    # From live data
    case type
    when 'photo'
      item.attachment = {"photo"=>{"pid"=>"2824048474384621129", "aid"=>"2824048478676582397", "height"=>"419", "index"=>"1", "owner"=>"657525024", "width"=>"580"}, "href"=>"http://www.facebook.com/photo.php?pid=3006025&amp;id=657525024", "src"=>"http://photos-b.ak.fbcdn.net/hphotos-ak-snc1/hs269.snc1/9630_149298465024_657525024_3006025_5207094_s.jpg", "type"=>"photo", "alt"=>{}}
    when 'video'
      item.attachment = "--- \nhref: http://www.facebook.com/ext/share.php?sid=118488009263&amp;h=Uk_ht&amp;u=e8Tgi\ntype: video\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=98ddec74796e916446bbe3468c840250&amp;url=http%3A%2F%2Fi.ytimg.com%2Fvi%2FxgHmSdpjEIk%2F2.jpg&amp;w=130&amp;h=130\nalt: Thousand-Hand Guan Yin\nvideo: \n  permalink: /posted.php?id=504883639&amp;share_id=118488009263#s118488009263\n  source_url: http://www.youtube.com/v/xgHmSdpjEIk&amp;autoplay=1\n  display_url: http://www.youtube.com/watch?v=xgHmSdpjEIk&amp;eurl=http://www.facebook.com/home.php?ref=home&amp;feature=player_embedded#t=124\n  owner: \"504883639\"\n  source_type: html\n"
    when 'generic'
      item.attachment = "--- \nname: \"Is the SexTracker Creator a Monster? \\xC2\\xAB The Gonzo Fat Savage Lifestyle\"\nhref: http://www.facebook.com/ext/share.php?sid=128131996883&amp;h=iNgGX&amp;u=kmFJK\nfb_object_type: {}\n\nfb_object_id: {}\n\nicon: http://static.ak.fbcdn.net/rsrc.php/zADLZ/hash/ezwlslya.gif\nmedia: {}\n\ncaption: \"Source: fatsavage.wordpress.com\"\ndescription: \"It\\xE2\\x80\\x99s kind of hard to figure out if Andrew Edmond is a creep, cop, criminal or con-man. I mean I\\xE2\\x80\\x99ve never met the man and he never sent me a copy of his resume so I have to develop his profile from online information. ...\"\nproperties: {}\n\n"
    when 'friendfeed'
      item.attachment_type = 'generic'
      item.attachment = "--- \nhref: http://www.facebook.com/\nfb_object_type: {}\n\nfb_object_id: {}\n\nicon: http://photos-f.ak.fbcdn.net/photos-ak-sf2p/v43/209/2795223269/app_2_2795223269_1202.gif\nmedia: {}\n\ndescription: \"&lt;div class=&quot;CopyTitle&quot;&gt;Marc posted &lt;a rel=&quot;nofollow&quot; href=&quot;http://www.amazon.com/dp/0887307280/&quot; onclick=&quot;(new Image()).src = &amp;#039;/ajax/ct.php?app_id=2795223269&amp;amp;action_type=3&amp;amp;post_form_id=6657946eb0d4e5ad7a77b966f4e0a040&amp;amp;position=14&amp;amp;&amp;#039; + Math.random();return true;&quot;&gt;The E-Myth Revisited: Why Most Small Businesses Don't Work and What to Do About It&lt;/a&gt; via &lt;a href=&quot;http://apps.facebook.com/friendfeed/&quot; onclick=&quot;(new Image()).src = &amp;#039;/ajax/ct.php?app_id=2795223269&amp;amp;action_type=3&amp;amp;post_form_id=6657946eb0d4e5ad7a77b966f4e0a040&amp;amp;position=14&amp;amp;&amp;#039; + Math.random();return true;&quot;&gt;FriendFeed&lt;/a&gt;&lt;/div&gt;\"\nproperties: {}\n\n"
    when 'link'
      item.attachment = "--- \nhref: http://www.facebook.com/ext/share.php?sid=123275557061&amp;h=AS8HB&amp;u=zFAlt\ntype: link\nsrc: http://external.ak.fbcdn.net/safe_image.php?d=bfbd14a77a70e85673eb9cd537214304&amp;url=http%3A%2F%2Ffarm4.static.flickr.com%2F3456%2F3829703647_8276334e5d_o.jpg&amp;w=130&amp;h=130\n"
    when 'link_with_description'
      item.attachment = {'name' => 'name', 'description' => 'description', 'caption' => 'caption'}
    end
    item
  end
  
  def create_facebook_stream_proxy_item_with_comments(num=1)
    returning (ActivityStreamProxy.new) do |item|
      comms = []
      num.times { comms <<  new_proxy_fb_comment(facebook_backup_comment) }
      item.comments = comms
    end
  end
  
  def create_facebook_stream_proxy_item_with_likes
    returning (ActivityStreamProxy.new) do |item|
      item.likers = ["john brown", "karl malone"]
    end
  end
  
  # Simulates complicated FacebookBackup::FacebookComment created by backup system
  def facebook_backup_comment
    stub('FacebookBackup::FacebookComment', 
      :xid => rand.to_s,
      :fromid => rand,
      :time => (Time.now - rand(100).days).to_i,
      :text => Faker::Lorem.sentence,
      :id => rand.to_s,
      :user_data => {
        :username => Faker::Lorem.name,
        :user_pic => Faker::Internet.domain_name,
        :profile_url => Faker::Internet.domain_name
      }
      )
  end
end
