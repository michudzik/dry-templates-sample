class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    Users::Create.new.call(user_params) do |r|
      r.success { |_| return redirect_to users_path, notice: 'User created' }
      r.failure(:build) { @errors = ['Unknown attributes passed'] }
      r.failure(:validate) { |user| @errors = user.errors.full_messages }
      r.failure(:save) { return redirect_to users_path, alert: 'Database connection lost' }
    end

    @user = User.new
    render :new
  end

  def update
    Users::Update.new.call(user_params.merge(id: params[:id])) do |r|
      r.success { return redirect_to users_path, notice: 'User updated' }
      r.failure(:find) { return redirect_to users_path, alert: 'User not found' }
      r.failure(:validate) { |user| @errors = user.errors.full_messages }
      r.failure(:save) { return redirect_to users_path, alert: 'Database connection lost' }
    end

    render :edit
  end

  def index
    Users::Index.new.call do |r|
      r.success { |users| @users = users }
      r.failure { redirect_to root_path, alert: 'Database connection lost' }
    end
  end

  def show
    Users::Fetch.new.call(params[:id]) do |r|
      r.success { |user| @user = user }
      r.failure(:find) { |_| redirect_to users_path, alert: 'User not found' }
    end
  end

  def destroy
    Users::Destroy.new.call(params[:id]) do |r|
      r.success { |_| redirect_to users_path, notice: 'User deleted' }
      r.failure(:find) { |_| redirect_to users_path, alert: 'User not found' }
      r.failure(:delete) { |_| redirect_to users_path, alert: 'Database connection lost' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
