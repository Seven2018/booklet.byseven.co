class TrainingsController < ApplicationController

  def show
    @training = Training.find(params[:id])
    authorize @training
  end

  def create
    @training = Training.new(training_params)
    authorize @training
    @training.company_id = current_user.company_id
    if @training.save
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @training = Training.find(params[:id])
    authorize @training
    @training.destroy
    redirect_to dashboard_path
  end

  private

  def training_params
    params.require(:training).permit(:title, :folder_id, :auth_token)
  end
end
