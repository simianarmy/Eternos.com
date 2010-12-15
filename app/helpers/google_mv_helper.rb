module GoogleMvHelper
  MVSections = {
    :home_signup_h1 => [
      %(Sign up to create your digital archive, it's free, the peace of mind is priceless!),
      %(Sign up for your free digital archive and enjoy priceless peace of mind.),
      %(Sign up for the peace of mind that comes with your free digital archive.),
      %(Archive your digital assets for free; auto-archiving of Facebook, Twitter, and more!),
      %(Sign up for free archiving of your digital assets!)
    ]
  }
  
  def google_mv_utmx_section(name)
    section_idx = rand(MVSections[name.to_sym].size) + 1
    section_copy = MVSections[name.to_sym][section_idx-1]
    
    %[<script>utmx_section("#{name.to_s}_#{section_idx}")</script>
	  <h1>#{section_copy}</h1>
	  </noscript>]
  end
end
