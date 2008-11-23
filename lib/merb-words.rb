if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-ui'
  Merb::Plugins.add_rakefiles "merb-words/merbtasks", "merb-words/slicetasks", "merb-words/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)

  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to
  # the main application layout or no layout at all if needed.
  #
  # Configuration options:
  # :layout - the layout to use; defaults to :merb-words
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:merb_words][:layout] ||= :application

  # All Slice code is expected to be namespaced inside a module
  module MerbWords

    # Slice metadata
    self.description = "Merb UI Words"
    self.version = "1.0"
    self.author = "UI Poet"

    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end

    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end

    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end

    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbWords)
    def self.deactivate
    end

    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_words_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.to(:controller => 'pages') do |p|
        p.match('/pages').to(:action => 'index').name(:index)
        p.match('/pages/feed').to(:action => 'feed').name(:feed)
        p.match('/page/create', :method => :post).to(:action => 'create_post').name(:create)
        p.match('/page/create').to(:action => 'create').name(:create)
        p.match('/page/read/:page_id').to(:action => 'read').name(:read)
        p.match('/page/update/:page_id', :method => :put).to(:action => 'update_put').name(:update)
        p.match('/page/update/:page_id').to(:action => 'update').name(:update)
        p.match('/page/delete/:page_id', :method => :delete).to(:action => 'delete_delete').name(:delete)
        p.match('/page/delete/:page_id').to(:action => 'delete').name(:delete)
        p.match('/search/delete/:search').to(:action => 'search_delete').name(:search_delete)
      end
      scope.to(:controller => 'categories') do |c|
        c.match('/category/create', :method => :post).to(:action => 'create_post').name(:category_create)
        c.match('/category/create').to(:action => 'create').name(:category_create)
        c.match('/category/update/:category_id', :method => :put).to(:action => 'update_put').name(:category_update)
        c.match('/category/update/:category_id').to(:action => 'update').name(:category_update)
        c.match('/category/delete/:category_id', :method => :delete).to(:action => 'delete_delete').name(:category_delete)
        c.match('/category/delete/:category_id').to(:action => 'delete').name(:category_delete)
      end
      scope.to(:controller => 'passwords') do |p|
        p.match('/password/exit').to(:action => 'exit').name(:password_exit)
        p.match('/password/create', :method => :post).to(:action => 'create_post').name(:password_create)
        p.match('/password/create').to(:action => 'create').name(:password_create)
        p.match('/password/read', :method => :post).to(:action => 'read_post').name(:password_read)
        p.match('/password/read').to(:action => 'read').name(:password_read)
        p.match('/password/update', :method => :post).to(:action => 'update_post').name(:password_update)
        p.match('/password/update').to(:action => 'update').name(:password_update)
        p.match('/password/delete', :method => :delete).to(:action => 'delete_delete').name(:password_delete)
        p.match('/password/delete').to(:action => 'delete').name(:password_delete)
      end
    end

  end

  # Setup the slice layout for MerbWords
  #
  # Use MerbWords.push_path and MerbWords.push_app_path
  # to set paths to merb-words-level and app-level paths. Example:
  #
  # MerbWords.push_path(:application, MerbWords.root)
  # MerbWords.push_app_path(:application, Merb.root / 'slices' / 'merb-words')
  # ...
  #
  # Any component path that hasn't been set will default to MerbWords.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  MerbWords.setup_default_structure!

  # Add dependencies for other MerbWords classes below. Example:
  # dependency "merb-words/other"

end