class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # Index with "search" option
  def index
    @requests = policy_scope(Request)
    @requests = Request.joins(:user).where(users.company.id == current_user.company.id) if current_user.access_level == 'HR'
    @requests = Request.where(user_id: current_user.id) if current_user.access_level == 'Employee'
    @requests = @requests.joins(:user).where("lower(users.firstname) LIKE ?", "%#{params[:search][:name].downcase}%").order(lastname: :asc) + @requests.joins(:user).where("lower(users.lastname) LIKE ?", "%#{params[:search][:name].downcase}%").order(lastname: :asc) if params[:search] && ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level)
  end

  def show
    authorize @request
    @request = Request.where(user_id: current_user.id).first if (current_user.access_level == 'Employee' && @request.user_id != current_user.id)
  end

  def create
    @request = Request.new
    authorize @request
    @request.user_id = current_user.id
    @request.training_program_id = params[:training_program_id]
    @request.status = 'Pending'
    @request.save ? (redirect_to request_path(@request)) : (render :new)
  end

  def update
    authorize @request
    @request.update(status: params[:request_status])
    @request.save ? (redirect_to request_path(@request)) : (render '_edit')
  end

  def destroy
    @request.destroy
    authorize @request
    redirect_to requests_path
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end
end
