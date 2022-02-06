class HomeController < ApplicationController

  before_action :authenticate_user!, except: [:handle_no_rout, :confirmation]
  before_action :set_from_to_date, except: [:handle_no_rout]


  def handle_no_rout
    # respond_to do |format|
    #   format.html { render "#{Rails.root}/public/404.html", status: 404 }
    #   format.json { render json: { status: 404, message: 'Page Not Found' } } #
    # end
    render :json => {:error => "Routing Error: Invalid url"}, :status => 404
  end

  def index
    render layout: 'home'
  end

  def confirmation
  end


end