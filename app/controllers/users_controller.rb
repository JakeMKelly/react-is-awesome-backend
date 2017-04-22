class UsersController < ApplicationController
  include Authorization

  def create
    user_params = params.require(:user).permit(:name, :password, :is_admin?).tap do |user_params|
      user_params.require([:name, :password])
    end
    user = User.new(user_params)
    begin
      user.save!
      render json: {
        id: user.id,
        name: user.name,
      }
    rescue ActiveRecord::RecordNotUnique
      render json: {type: "UserExists", message: "#{user_params[:name]} already exists in the database, pick another name"}, status: 400
    end
  end

  def update
    require_self
    user_params = params.require(:user).permit(:password).tap do |user_params|
      user_params.require(:password)
    end
    user = User.find(params[:id])
    user.update_attributes(user_params)
    render json: {
      id: user.id,
      name: user.name
    }
  end
end
