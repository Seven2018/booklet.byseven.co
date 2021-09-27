class TrainingsController < ApplicationController

  def show
    @training = Training.find(params[:id]).folder
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

  private

  def training_params
    params.require(:training).permit(:title, :folder_id, :auth_token)
  end
end
