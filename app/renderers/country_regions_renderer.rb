# $Id$
class CountryRegionsRenderer < Renderer
  def hide_regions(region_domid)
    #page.hide 'country_region'
    # Reset region select value
    page.replace_html region_domid, ''
    page.hide region_domid
  end
  
  def update_regions(region_domid, regions)
    page.show region_domid
    page.replace_html region_domid, :partial => 'country_regions', :locals => { :regions => regions }
    page.visual_effect :highlight, region_domid + '_container', :duration => 1.0
  end
end
