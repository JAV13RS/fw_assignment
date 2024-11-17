class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show,:create_collection, :show_collection, :update_collection, :destroy_collection]
    before_action :authorize_admin_status, only: [:update]
    before_action :set_user, only: [:update, :destroy, :collections, :create_collection, :show_collection, :update_collection, :destroy_collection]
  
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
    

    def flashcard_sets
        user = User.find_by(id: params[:user_id])
        
        respond_to do |format|
            if user
                format.json { render json: user.flashcard_sets, status: :ok }
                format.html { render :flashcard_sets }
            else
                format.json { render json: { error: 'User not found' }, status: :not_found }
                format.html { redirect_to users_path, alert: 'User not found' }
            end
        end
    end

    def collections
        @collections = @user.collections.includes(:flashcard_sets)
    
        respond_to do |format|
          format.html 
          format.json { render json: @collections.map { |collection| 
            {
              set: collection.flashcard_sets.map { |set| 
                {
                  id: set.id,
                  name: set.name,
                  created_at: set.created_at,
                  updated_at: set.updated_at
                }
              }
            }
          } }
        end
    end

    def create_collection
        @collection = @user.collections.new(collection_params)
    
        respond_to do |format|
          if @collection.save
            format.html { redirect_to user_collections_path(@user), notice: 'Collection was successfully created.' }
            format.json { render json: @collection, status: :created }
          else
            format.html { render :new }
            format.json { render json: @collection.errors, status: :unprocessable_entity }
          end
        end
    end

    def show_collection
        respond_to do |format|
          format.html 
          format.json { render json: {
            set: @collection.flashcard_sets.map { |set| 
              {
                id: set.id,
                name: set.name,
                created_at: set.created_at,
                updated_at: set.updated_at
              }
            },
            user: {
              id: @user.id,
              email: @user.email
            }
          } }
        end
    end
   
    def update_collection
        respond_to do |format|
          if @collection.update(collection_params)
            format.html { redirect_to user_collection_path(@user, @collection), notice: 'Collection was successfully updated.' }
            format.json { render json: @collection, status: :ok }
          else
            format.html { render :edit }
            format.json { render json: @collection.errors, status: :unprocessable_entity }
          end
        end
    end
  
    def destroy_collection
        @collection.destroy
        respond_to do |format|
            format.html { redirect_to user_collections_path(@user), notice: 'Collection was successfully deleted.' }
            format.json { head :no_content }
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

    def set_collection
        @collection = @user.collections.find_by(id: params[:collection_id])
        return render json: { error: 'Collection not found' }, status: :not_found unless @collection
    end


end
  