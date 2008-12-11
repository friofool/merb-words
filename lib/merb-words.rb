if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  #load_dependency 'merb-ui'
  dependencies 'merb-ui'
  Merb::Plugins.add_rakefiles "merb-words/merbtasks", "merb-words/slicetasks", "merb-words/spectasks"

  Merb::Slices::register(__FILE__)

  Merb::Slices::config[:merb_words][:layout] ||= :application

  module MerbWords

    def self.setup_router(scope)
      scope.to(:controller => 'pages') do |p|
        p.match('/').to(:action => 'index').name(:index)
        p.match('/feed').to(:action => 'feed').name(:feed)
        p.match('/create', :method => :post).to(:action => 'create_post').name(:create)
        p.match('/create').to(:action => 'create').name(:create)
        p.match('/read/:page_id').to(:action => 'read').name(:read)
        p.match('/update/:page_id', :method => :put).to(:action => 'update_put').name(:update)
        p.match('/update/:page_id').to(:action => 'update').name(:update)
        p.match('/delete/:page_id', :method => :delete).to(:action => 'delete_delete').name(:delete)
        p.match('/delete/:page_id').to(:action => 'delete').name(:delete)
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

  MerbWords.setup_default_structure!

end