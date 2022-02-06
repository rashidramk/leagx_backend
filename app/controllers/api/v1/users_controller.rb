class Api::V1::UsersController < ApplicationController

  # skip_before_action :verify_authenticity_token

  # before_action :verify_api_token, except: [:create, :forgot_password, :social_auth]
  before_action :set_user, only: [:show, :update, :destroy, :update_password, :get_workout_history]
  before_action :check_user_with_email, only: [:social_auth]
  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user, include: [:user_devices]
  end

  # POST /users
  def create
    unless @user
      @user = User.new(user_params)
      # debugger
    end
    pass = params[:user][:password]
    @user.password=@user.password_confirmation=pass
    # debugger
    @user.confirmation_token = nil
    @user.confirmed_at = DateTime.now    
    if @user.save
      @user.setup_devices(params[:PushToken]) if params[:PushToken].present?
      render json: @user, status: :created
    else
      render :json => {:error => "Unable to create user at this time.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def update_password
    if @user.update(user_params)
      render json: @user
    else
      render :json => {:error => "Record not found"}, :status => :unprocessable_entity
    end
  end

  def forgot_password
    @user = User.find_by_email(params[:email].downcase)
    if @user.present?
      @user.send_reset_password_instructions
      render :json => {:success => "Please check your email #{@user.email} for password reset instructions"}, :status => :created
    else
      render :json => {:error => "Email not found"}, :status => :unprocessable_entity
    end
  end

  # need refactoring, social auth
  def social_auth
    unless @user
      @user = User.where(uid: params[:user][:uid]).first_or_initialize do |user|
        user.email = params[:user][:email].downcase
        user.first_name = params[:user][:first_name]
        user.last_name = params[:user][:last_name]
        user.password = 'swolefb123' #Test Passwor
      end
    end
    @user.provider = params[:user][:provider]
    @user.uid = params[:user][:uid]
    # by pass confirmation
    @user.confirmation_token = nil
    @user.confirmed_at = DateTime.now
    if @user.provider.present? && @user.save
      @user.setup_devices(params[:PushToken]) if params[:PushToken].present?
      render json: @user, include: [:user_devices], status: :ok
    else
      render :json => {:error => "Unable to create user at this time.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def get_workout_history
    hisotry = @user.user_workout_histories.order("created_at DESC").pluck(:workout_id)
    re = []
    hisotry.each do |h|
      w= Workout.find_by(id: h)
     if w.present?
       wp = JSON.parse(w.to_json)
       wp[:category] = JSON.parse(w.category.to_json)
       re.push(wp)
     end
    end
    render :json => re
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    begin
      @user = User.find(params[:id] || params[:user_id])
      render :json => {:error => "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end
  
  def check_user_with_email
    return nil if params[:user][:email].blank?
    # @user1 = User.find_by_email(params[:user][:email])
    @user = User.where('email=? AND uid IS NULL', params[:user][:email].downcase).first
  end

  # Only allow a trusted parameter “white list” through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone, :gender, :address, :dob, :provider, :uid)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if request.headers[:apitoken].blank?
    User.find_by(api_token: request.headers[:apitoken])
  end

end