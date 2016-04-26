class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin, only: [:index, :new, :create, :destroy]

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if !@user.valid_password?(params.require(:user).permit(:current_password)[:current_password])
        @user.errors.add(:current_password, 'Das Passwort war nicht korrekt')
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      elsif @user.update(user_params)
        format.html { redirect_to dashboard_projects_path, notice: 'Passwort wurde geändert.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:old_password, :password, :password_confirmation)
    end
end
