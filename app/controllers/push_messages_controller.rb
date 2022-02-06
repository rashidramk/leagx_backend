class PushMessagesController < ApplicationController

  before_action :authenticate_user!

  before_action :set_push_message, only: [:show, :edit, :update, :destroy]
  layout 'home'
  # GET /PushMessages
  # GET /PushMessages.json
  def index
    @push_messages = PushMessage.where(search_condition(PushMessage)).order("created_at DESC").paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /PushMessages/1
  # GET /push_messages/1.json
  def show
  end

  # GET /push_messages/new_admin
  def new
    @push_message = PushMessage.new
  end

  # GET /push_messages/1/edit
  def edit
  end

  # PushMessage /push_messages
  # PushMessage /push_messages.json
  def create
    @push_message = PushMessage.new(push_message_params)

    respond_to do |format|
      if @push_message.save
        format.html { redirect_to push_messages_path, notice: 'PushMessage was successfully created.' }
        format.json { render :show, status: :created, location: @push_message }
      else
        format.html { render :new }
        format.json { render json: @push_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /push_messages/1
  # PATCH/PUT /push_messages/1.json
  def update
    respond_to do |format|
      if @push_message.update(push_message_params)
        format.html { redirect_to push_messages_path, notice: 'PushMessage was successfully updated.' }
        format.json { render :show, status: :ok, location: @push_message }
      else
        format.html { render :edit }
        format.json { render json: @push_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /push_messages/1
  # DELETE /push_messages/1.json
  def destroy
    @push_message.destroy
    respond_to do |format|
      format.html { redirect_to push_messages_url, notice: 'PushMessage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_push_message
    @push_message = PushMessage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def push_message_params
    params.require(:push_message).permit(:id, :description, :title)
  end
end
