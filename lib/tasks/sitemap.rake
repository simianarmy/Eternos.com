# $Id$

# Rake tasks for generating sitemaps

namespace :sitemap do
  def write_sitemap_xml(sitemap, page)
    #delete the previous
    xml_filename = File.join(RAILS_ROOT, "public/#{page}_sitemap.xml")
    FileUtils.rm("#{xml_filename}.gz", :force => true)

    #create the new file
    f = File.new(xml_filename, 'w')
    f.write sitemap.to_xml
    f.close

    #compress
    system("gzip #{xml_filename}")
  end
  
  # Example of how to create a sitemap for one model
  desc "Create Home Sitemap"
  task(:home => :environment) do
    sitemap = Sitemap.new
    sitemap.add_url(root_url)
    #add files depending on your application logic
    write_sitemap_xml(sitemap, 'home')
  end

  desc "Create About Sitemap"
  task :about => :environment do
    sitemap = Sitemap.new
    sitemap.add_url(about_url)
    sitemap.add_url("http://#{AppConfig.base_domain}/about/what")
    sitemap.add_url("http://#{AppConfig.base_domain}/about/press")
    sitemap.add_url("http://#{AppConfig.base_domain}/about/careers")
    sitemap.add_url("http://#{AppConfig.base_domain}/about/terms")
    sitemap.add_url("http://#{AppConfig.base_domain}/about/privacy")
    
    write_sitemap_xml(sitemap, 'about')
  end
    
  desc "Create Index"
  task(:index => :environment) do
    #add each sitemap file
    home = Sitemap.new("http://#{AppConfig.base_domain}/home_sitemap.xml.gz")
    about = Sitemap.new("http://#{AppConfig.base_domain}/about_sitemap.xml.gz")
    index = SitemapIndex.new
    
    index.add_sitemap(home)
    index.add_sitemap(about)

    #remove the previous file
    FileUtils.rm(File.join(RAILS_ROOT, "public/sitemap_index.xml.gz"), :force => true)

    #create the index file
    File.new(File.join(RAILS_ROOT, "public/sitemap_index.xml"), 'w') do |f|
      f.write index.to_xml
    end

    #compress
    system("gzip #{File.join(RAILS_ROOT, 'public/sitemap_index.xml')}")
  end

  desc "Create all sitemaps"
  task(:generate=> :environment) do
    require File.join(RAILS_ROOT, 'lib/sitemap')
    
    #create all sitemap files
    Rake::Task["sitemap:home"].invoke
    Rake::Task["sitemap:about"].invoke

    #create the sitemap index file 
    Rake::Task["sitemap:index"].invoke
  end
end
