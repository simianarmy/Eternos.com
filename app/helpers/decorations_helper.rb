# $Id$

module DecorationsHelper
  def build_decoration_path(parent, options={})
    options.merge! model_to_hash(parent)
    options[:only_path] = true # Prevents flash crossdomain security errors when localhost
    if dec = options.delete(:decoration)
      url_for({:controller=>:decorations, :action => :show, :id => dec.id}.merge(options))
    else
      options[:action] ||= :index
      url_for({:controller => :decorations}.merge(options))
    end
  end
  
  private
  
  def model_to_hash(object)
    {:owner_id => object.id, :owner => object.to_str}
  end
end