class HoursController < ApplicationController
  
  before_filter :authenticate_user!

  def create
    @task = Task.find(params[:task_id])
    @hour = @task.hours.create(params[:hour])
    redirect_to task_path(@task)
  end
  
  def destroy
    @task = Task.find(params[:task_id])
    @hour = @task.hours.find(params[:id])
    @hour.destroy
    redirect_to task_path(@task)
  end
end
