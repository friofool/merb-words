class MerbWords::Categories < MerbWords::Application

  before(:mui_window_referer, :only => [:create, :update, :delete])

  def create
    display(@category = Category.new, :layout => false)
  end

  def create_post
    category = Category.new(params[:category])
    if category.save
      session[:mui_message] = {:title => 'Category created', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to create category', :body => mui_list(category.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:category_create)
    end
    mui_window_redirect
  end

  def update
    display(@category = Category.get!(params[:category_id]), :layout => false)
  end

  def update_put
    category = Category.get!(params[:category_id])
    if category.update_attributes(params[:category])
      session[:mui_message] = {:title => 'Category updated', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to update category', :body => mui_list(category.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:category_update)
    end
    mui_window_redirect
  end

  def delete
    display(@category = Category.get!(params[:category_id]), :layout => false)
  end

  def delete_delete
    category = Category.get!(params[:category_id])
    category.pages.clear
    category.save
    if category.destroy
      session[:mui_message] = {:title => 'Category deleted', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to delete category', :body => mui_list(category.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:category_delete)
    end
    mui_window_redirect
  end

end
