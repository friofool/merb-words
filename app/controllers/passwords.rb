class MerbWords::Passwords < MerbWords::Application

  before(:mui_window_referer, :only => [:exit, :create, :read, :update, :delete])
  before(:merb_words_password_redirect, :exclude => [:exit, :create, :read], :unless => :merb_words_password?)

  def exit
    session.delete(:mui_password_id)
    session[:mui_message] = {:title => 'Exited', :tone => 'positive'}
    mui_window_redirect
  end

  def create
    display(@password = Password.new, :layout => false)
  end

  def create_post
    password = Password.new(params[:password])
    if password.save
      session[:mui_password_id] = password.id
      session[:mui_message] = {:title => 'Password created', :tone => 'positive'}
      mui_window_redirect
    else
      session[:mui_message] = {:title => 'Unable to create password', :body => mui_list(password.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:password_create)
      mui_window_redirect
    end
  end

  def read
    if Password.first
      display(@password = Password.new, :layout => false)
    else
      redirect slice_url(:password_create)
    end
  end

  def read_post
    encrypted = encrypt(params[:password])
    if password_match = Password.first(:encrypted => encrypted)
      session[:mui_password_id] = password_match.id
      session[:mui_message] = {:title => 'Password correct', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Password incorrect', :tone => 'negative'}
      session[:mui_window] = slice_url(:password_read)
    end
    mui_window_redirect
  end

  def update
    display(@password = Password.new, :layout => false)
  end

  def update_post
    password = Password.get!(session[:mui_password_id])
    if password.update_attributes(params[:password])
      session[:mui_message] = {:title => 'Password updated', :tone => 'positive'}
    else
      session[:mui_message] = {:title => 'Unable to update password', :body => mui_list(password.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:password_update)
    end
    mui_window_redirect
  end

  def delete
    render :layout => false
  end

  def delete_delete
    password = Password.get!(session[:mui_password_id])
    if password.destroy
      session.delete(:mui_password_id)
      session[:mui_message] = {:title => 'Password deleted', :tone => 'positive'}
      mui_window_redirect
    else
      session[:mui_message] = {:title => 'Unable to delete password', :body => mui_list(password.errors), :tone => 'negative'}
      session[:mui_window] = slice_url(:password_delete)
      mui_window_redirect
    end
  end

  protected

  require "digest/sha1"

  def encrypt(password)
    Digest::SHA1.hexdigest("--#{password[:password]}--")
  end

end
