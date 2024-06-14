class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  def index
    @users = User.all
    render json: @users.map { |user|
      if user.avatar.attached?
        user.as_json(only: %i[name]).merge(avatar_path: url_for(user.avatar))
      else
        user.as_json(only: %i[name])
      end
    }
  end

  def show
    @user = User.find(params[:id])
    if @user.avatar.attached?
      render json: {data: @user, image: url_for(@user.avatar)}
    else
      render json: @user.as_json(only: %i[name])
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(parmas[:id])
    u_id = params[:id]
    u_id = u_id.to_i
    if u_id != @current_user
      render json: {error: "You are not Authorized"}
    else
      if @user.update(user_params)
        render json: @user, status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user = User.find(parmas[:id])
    u_id = params[:id]
    u_id = u_id.to_i
    if u_id != @current_user
      render json: {error: "You are not Authorized"}
    else
      @user.destroy
      render json: { message: 'User deleted' }, status: :ok
    end
  end

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true) if avatar.attached?
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(:avatar, :name, :username, :email, :fullname, :password, :password_confirmation)
  end
end
