class TasksController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :set_timezone
  
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.tasks.order("priority DESC")
    @tasks_by_day = Array.new
    
    # tasks_by_day is used by the index page to display
    # all tasks on a single chart (requiring a 2D array)
    @tasks_by_day[0] = Array.new
    @tasks_by_day[0][0] = "Day"
    
    for i in 0...30
      @tasks_by_day[i+1] = Array.new
      @tasks_by_day[i+1][0] = "new Date(#{Date.today.year}, 0, #{Date.today.yday - (i)})"
    end
    
    @tasks.reverse.each_with_index do |task, i|
      @tasks_by_day[0][i+1] = task.name
      
      task.by_period(:day, 30).each_with_index do |hour, j|
        @tasks_by_day[j+1][i+1] = hour
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = current_user.tasks.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = current_user.tasks.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
  
  def set_timezone
    Time.zone = current_user.time_zone
  end
end
