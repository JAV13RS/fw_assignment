class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show]
    before_action :authorize_admin_status, only: [:update]
    before_action :set_user, only: [:update, :destroy]
  
    def index
      @users = User.all
      respond_to do |format|
        format.json { render json: @users, status: :ok }
        format.html { render :index }  
      end
    end
  
    def show
      @user = User.find_by(id: params[:id])
  
      respond_to do |format|
        if @user
          format.json { render json: @user, status: :ok }
          format.html { render :show }  
        else
          format.json { render json: { error: 'User not found' }, status: :not_found }
          format.html { redirect_to users_path, alert: 'User not found' }
        end
      end
    end
  
    def create
      @user = User.new(user_params)
  
      respond_to do |format|
        if @user.save
          format.json { render json: @user, status: :created }
          format.html { redirect_to @user, notice: 'User was successfully created.' }
        else
          format.json { render json: { error: @user.errors.full_messages }, status: :bad_request }
          format.html { render :new }
        end
      end
    end
  
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.json { render json: @user, status: :ok }
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
        else
          format.json { render json: { error: @user.errors.full_messages }, status: :unprocessable_entity }
          format.html { render :edit }
        end
      end
    end
  
    def destroy
      respond_to do |format|
        if @user.destroy
          format.json { head :no_content }
          format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
        else
          format.json { render json: { error: 'Unable to delete user' }, status: :unprocessable_entity }
          format.html { redirect_to users_url, alert: 'Unable to delete user' }
        end
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :admin)
    end
  
    def authorize_admin_status
      if user_params[:admin] && !current_user.admin?
        respond_to do |format|
          format.json { render json: { error: 'Only admins can modify admin status' }, status: :forbidden }
          format.html { redirect_to users_path, alert: 'Only admins can modify admin status' }
        end
      end
    end
  
    def set_user
      @user = User.find_by(id: params[:id])
      unless @user
        respond_to do |format|
          format.json { render json: { error: 'User not found' }, status: :not_found }
          format.html { redirect_to users_path, alert: 'User not found' }
        end
      end
    end
  end
  