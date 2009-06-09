module LinksHelper
  def begin_story_link
    capture(render(:partial => 'stories/tooltips/begin_story_options')) do |tips|
      l = link_to('create', begin_story_path, :id => 'begin_story', 
        :class => 'tooltip-target', :rel => "{closeButton: false, hideOn: { element: 'tip', event: 'mouseleave' }, fixed: true, showOn: 'click', hook: {target: 'topRight', tip: 'bottomLeft'}, stem: 'bottomLeft'}"
        )
      l + tips
    end
  end
  
  # Helper to create links with basic tooltip capability
  # (tooltip message should be defined after this call)
  def link_to_with_tooltip(name, target, *args, &proc)
    args << returning(args.extract_options!) do |options|
      options[:class] = 'tooltip-target ' + options[:class].to_s
      options[:rel] = default_prototip_options
    end
    link_to name, target, *args, &proc
  end
end