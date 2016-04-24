# encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:new, :create]

  # GET /sessions
  def index
    @session = Session.find
    if @session
      redirect_to dashboard_projects_path
    else
      redirect_to new_session_path
    end
  end

  # GET /sessions/new
  # GET /sessions/new.json
  def new
    @session = Session.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @session }
    end
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = Session.new session_params
    respond_to do |format|
      if @session.save
        log 'SUCCESS'
        format.html { redirect_to sessions_path, notice: 'Angemeldet.' }
        format.json { render json: @session, status: :created }
      else
        log 'FAILURE'
        format.html { render action: 'new' }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session = Session.find
    @session.destroy if @session

    respond_to do |format|
      format.html { redirect_to new_session_url }
      format.json { head :ok }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(:username, :password)
    end

  protected

  def log status
    File.open( File.join( Rails.root, 'data', 'logins', Date.today.strftime( '%Y-%m-%d' )), 'a') do |file|
      file.puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')}\t#{request.remote_ip}\t#{@session.username}\t#{status}"
    end
  end
end
