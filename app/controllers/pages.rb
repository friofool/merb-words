require 'cgi'

class MerbWords::Pages < MerbWords::Application

  before(:mui_window_referer, :only => [:create, :update, :delete])
  before(:merb_words_password_redirect, :exclude => [:index, :feed, :read], :unless => :merb_words_password?)
  before(:merb_words_orders, :only => [:index])

  def index
    if Page
      filters = {}
      filters[:publish] = true unless merb_words_password?
      @order_property = params[:order_property] || MerbWords[:order] || 'created_at'
      if @order_property == 'title'
        filters[:order] = [@order_property.intern.asc]
      else
        filters[:order] = [@order_property.intern.desc]
      end
      if search = params[:search] and !search.blank?
        search = CGI.escape(search).to_a
        if searches = session[:mui_searches]
          session[:mui_searches] = searches | search
        else
          session[:mui_searches] = search
        end
        pages_title = Page.all(:title.like => "%#{search}%")
        pages_body = Page.all(:body.like => "%#{search}%")
        @pages = pages_title | pages_body
      elsif @category_id = params[:category_id]
        @pages = Category.get!(@category_id).pages(filters)
      else
        @pages = Page.all(filters)
      end
      @categories = Category.all(:order => [:title.asc])
      @orders = Order.all
      display @pages
    else
      session[:mui_message] = {:title => 'Create the first page'} if merb_words_password?
      session[:mui_window] = slice_url(:create)
      render
    end
  end

  def feed
    only_provides :xml
    display @pages = Page.all(:publish => true) if Page.first
  end

  def create
    display(@page = Page.new, :layout => false)
  end

  def create_post
    params[:page][:categories].collect!{|c| Category[c]} if params[:page][:categories]
    page = Page.new(params[:page])
    if page.save
      session[:mui_message] = {:title => 'Page created', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to create page', :body => mui_list(page.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:create)
    end
    mui_window_redirect
  end

  def read
    display @page = Page.get!(params[:page_id])
  end

  def update
    @page = Page.get!(params[:page_id])
    @page.body = escape_xml(@page.body)
    display(@page, :layout => false)
  end

  def update_put
    page = Page.get!(params[:page_id])
    page.categories.clear
    page.save
    params[:page][:categories].collect!{|c| Category[c]} if params[:page][:categories]
    if page.update_attributes(params[:page])
      session[:mui_message] = {:title => 'Page updated', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to update page', :body => mui_list(page.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:create)
    end
    mui_window_redirect
  end

  def delete
    display(@page = Page.get!(params[:page_id]), :layout => false)
  end

  def delete_delete
    page = Page.get!(params[:page_id])
    page.categories.clear
    page.save
    if page.destroy
      session[:mui_message] = {:title => 'Page deleted', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to delete page', :body => mui_list(page.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:delete)
    end
    redirect(slice_url(:index))
  end

  def search_delete
    session[:mui_searches] = session[:mui_searches] - params[:search].to_a
    redirect(slice_url(:index))
  end

end
