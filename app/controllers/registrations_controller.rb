class RegistrationsController < Devise::RegistrationsController
  def update
    @user = User.find(current_user.id)
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?
    
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("delete_confirmation")
      params[:user].delete("current_password")
    end
    
    successfully_updated = if email_changed or password_changed
      @user.update_with_password(params[:user])
    else
      @user.update_without_password(params[:user])
    end
    
    if successfully_updated
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end
end