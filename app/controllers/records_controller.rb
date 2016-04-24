class RecordsController < ApplicationController
  before_action :set_project
  before_action :set_record, only: [:show, :edit, :update, :destroy, :close]

  # GET /records
  # GET /records.json
  def index
    @records = @project.records
  end

  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = @project.records.build
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = @project.records.build(record_params)
    @record.user = current_user

    respond_to do |format|
      if @record.save
        format.html { redirect_to @project, notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: project_record_path(@project, @record) }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @project, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: project_record_path(@project, @record) }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to projects_url(@project), notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def open
    Record.close_last_record_for(current_user.id)
    @record = @project.records.build
    @record.user = current_user
    @record.begun_at = Time.now
    @record.save!

    respond_to do |format|
      format.html { redirect_to dashboard_projects_url, notice: 'Begun work!' }
      format.json { head :no_content }
    end
  end

  def close
    fail "boo" unless Record.close_last_record_for(current_user.id)

    respond_to do |format|
      format.html { redirect_to dashboard_projects_url, notice: 'Stopped work!' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = project.records.find(params[:id])
    end

    def set_project
      @project = current_user.projects.find(params[:project_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:begun_at, :ended_at)
    end
end
