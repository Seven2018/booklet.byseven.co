class TrainingsController < ApplicationController

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
    params.require(:training).permit(:title, :auth_token)
  end
end
