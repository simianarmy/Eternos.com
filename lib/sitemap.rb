# $Id$

# Helper classes for building sitemaps
# Thanks to http://www.fortytwo.gr/blog/19/Generating-Sitemaps-With-Rails for code

class SitemapUrl < REXML::Element

  def initialize(loc, lastmod = nil, changefreq=nil, priority=nil)
    @loc = loc
    @lastmod = lastmod
    @changefreq = changefreq
    @priority = priority

    super("url")
    create_elements
  end

  def create_elements
    #add location
    el = self.add_element("loc")
    el.text = @loc

    if @lastmod
      el = self.add_element("lastmod")
      el.text = @lastmod
    end

    if @changefreq
      el = self.add_element("changefreq")
      el.text = @changefreq
    end

    if @priority
      el = self.add_element("priority")
      el.text = @priority
    end
  end

end

class Sitemap < REXML::Document

  attr_accessor :loc,:lastmod, :urls

  def initialize(loc=nil, lastmod=nil)
    super
    @loc = loc
    @lastmode = lastmod

    self << REXML::XMLDecl.new("1.0", "UTF-8")

    urlset = add_element("urlset")
    urlset.add_attribute("xmlns", "http://www.sitemaps.org/schemas/sitemap/0.9")

    @urls = self.root
  end

  def to_xml
    to_s
  end

  def add_url(loc, lastmod = nil, changefreq=nil, priority=nil)
    @urls << SitemapUrl.new(loc, lastmod, changefreq,priority)
  end

end

class SitemapIndex < REXML::Document
  attr_accessor :sitemaps

  def initialize
    super

    self << REXML::XMLDecl.new("1.0", "UTF-8")

    sitemapindex = add_element("sitemapindex")
    sitemapindex.add_attribute("xmlns", "http://www.sitemaps.org/schemas/sitemap/0.9")

  end

  def add_sitemap(sitemap)
    el = self.root.add_element("sitemap")
    loc = el.add_element("loc")
    loc.text = sitemap.loc
  end

  def to_xml
    to_s
  end
end

