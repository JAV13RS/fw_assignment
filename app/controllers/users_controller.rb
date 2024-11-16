class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index]

    def index
    @users = User.all
    render json: @users, status: :ok
    end

    def create
    @user = User.new(user_params)

        if @user.save
            render json: @user, status: :created
        else
            render json: { error: @user.errors.full_messages }, status: :bad_request
        end
    end

    private

    def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
