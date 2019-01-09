class UsersController < ApplicationController
  def create
    redirect_to new_user_path, notice: 'User created'
  end

  def destroy
    redirect_to new_user_path, notice: 'User deleted'
  end

  def new
  end

  def edit
  end

  def update
    redirect_to edit_user_path, notice: 'User updated'
  end

  def show
  end
end
