namespace :js do

  def minify(collection, cache_directory)

    # create cache directory
    FileUtils.mkdir_p cache_directory

    # paths to jsmin script and final minified file
    jsmin = 'script/javascript/jsmin.rb'

    collection.each_pair {|final, libs|

      # create single tmp js file
      tmp = Tempfile.open('all')
      libs.each {|lib| open(lib) {|f| tmp.write(f.read) } }
      tmp.rewind

      # minify file
      %x[ruby #{jsmin} < #{tmp.path} > #{final}]
      puts "Generated : #{final}"
    }
  end

  desc "Minify javascript src for production environment"
  task :min => [:min_lib]

  desc "Minify javascript action libraries for production environment"
  task :min_pages => :environment do

    collection = Hash.new
    namespaces = Array.new

    # Collect all the pages for minification
    dir = Dir.new('public/javascripts/pages')
    dir.each{|namespace|
      if namespace.match(/\.+/).nil?
        namespaces << namespace
      end
    }

    # Get controllers
    for namespace in namespaces
      dir = Dir.new('public/javascripts/pages/' + namespace)
      dir.each{|controller|
        if controller.match(/\.+/).nil?

          # Get actions
          current_dir = 'public/javascripts/pages/' + namespace + '/' + controller
          action_dir = Dir.new(current_dir)

          # Compile view specific js
          action_dir.each{|view|
            if !view.match(/\.js/).nil? && view.match(/\.js\./).nil?
              file =  namespace + "_" + controller + "_" + view
              collection['public/javascripts/cache/pages/' + file] = [current_dir + '/' + view]
            end
          }

        end
      }
    end

    # Run caching minification
    cache_dir = 'public/javascripts/cache/pages'
    minify(collection, cache_dir)
  end

  desc "Minify javascript libraries for production environment"
  task :min_lib => :environment do

    lib_cache_dir = 'public/javascripts/cache/'
    lib_global_dir = 'public/javascripts/'
    jquery_global_dir = 'public/javascripts/jQuery/'

    # list of library js to minify by namespace
    collection = {
      "#{lib_cache_dir}public.js" => [
        "#{lib_global_dir}prototype.js", 
        "#{lib_global_dir}scriptaculous.js",
        "#{lib_global_dir}effects.js",
        "#{lib_global_dir}controls.js",
        "#{lib_global_dir}lightview2.5.2.1/js/lightview.js",
        "#{lib_global_dir}flowplayer-3.1.4.min.js",
        "#{lib_global_dir}flowplayer.playlist-3.0.7.js",
        "#{lib_global_dir}lowpro.js",
        "#{lib_global_dir}defaultvalueactsashint.js",
        "#{lib_global_dir}behaviors.js",
        "#{lib_global_dir}facebook.js"
      ],
      "#{lib_cache_dir}account_setup.js" => [
        "#{lib_global_dir}prototype.js", 
        "#{lib_global_dir}scriptaculous.js",
        "#{lib_global_dir}effects.js",
        "#{lib_global_dir}controls.js",
        "#{lib_global_dir}application.js", 
        "#{lib_global_dir}login.js", 
        "#{lib_global_dir}account_setup.js"
        ],
      "#{lib_cache_dir}tools.js" => [
        "#{lib_global_dir}prototype.js", 
        "#{lib_global_dir}scriptaculous.js",
        "#{lib_global_dir}effects.js",
        "#{lib_global_dir}controls.js",
        "#{lib_global_dir}application.js", 
        "#{lib_global_dir}swfobject.js"
      ]
    }

    # Run caching minification
    minify(collection, lib_cache_dir)
  end
end