# $Id$
# $Id$

class AddressesController < ApplicationController
  def country_regions
    @regions ||= Country.find(params[:country_id].to_i).regions.collect {|r| [:id=>r.id, :name=>r.name]}
    respond_to do |format|
      format.js
    end
  end
end
