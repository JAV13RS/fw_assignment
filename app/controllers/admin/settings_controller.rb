class Admin::SettingsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
  
    def edit
      @setting = Setting.first || Setting.create(daily_set_limit: 20)
    end
  
    def update
      @setting = Setting.first
  
      if @setting.update(setting_params)
        redirect_to edit_admin_setting_path, notice: 'Daily limit updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def require_admin
      redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
    end
  
    def setting_params
      params.require(:setting).permit(:daily_set_limit)
    end
  end
  