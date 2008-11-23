module Merb::MerbWords::ApplicationHelper

  def merb_words_body(body)
    body.gsub(/\r\n|\r|\n/, '<br/>')
  end

  def merb_words_categories(options = {})
    attributes = {}
    attributes[:class] = 'mui_menu'
    attributes[:collection] = Category.all(:order => [:title.asc])
    attributes[:label] = 'Categories'
    attributes[:multiple] = 'multiple'
    attributes[:selected] = options[:categories].all.map {|c| c.id}
    attributes[:text_method] = :title
    attributes[:value_method] = :id
    select(:categories, attributes)
  end

  def merb_words_orders
    unless Order.first
      Order.create!(:property => 'created_at', :title => 'Date Created')
      Order.create!(:property => 'updated_at', :title => 'Date Updated')
      Order.create!(:property => 'title', :title => 'Title')
    end
  end

  def merb_words_password?
    session[:mui_password_id] ? true : false
  end

  def merb_words_password_redirect
    if Password.first
      redirect slice_url(:password_read)
    else
      redirect slice_url(:password_create)
    end
  end

  def merb_words_password_status
    if merb_words_password?
      update = mui_button(:title => 'Update', :url => slice_url(:password_update), :window => 'open')
      exit = mui_button(:title => 'Exit', :url => slice_url(:password_exit))
      mui_block(:type => 'status'){%{Password: #{update} #{exit}}}
    end
  end

  def merb_words_truncate(options = {})
    limit = options[:limit] || 50
    title = options[:title] || '...continued'
    page_parsed = options[:body].gsub(/<\/?[^>]*>/, '')
    page_split = page_parsed.split(/ /)
    if page_split.size > limit
      page_split.first(limit).join(' ') + tag(:i, title, :class => 'mui_truncate')
    else
      page_parsed
    end
  end

end