class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :edit, :update]

  # Show workshop view_mode
  def show
    authorize @workshop
  end

  # Show workshop edit_mode
  def edit
    authorize @workshop
  end

  # Update workshop attributes
  def update
    authorize @workshop
    @workshop.update(workshop_params)
    if @workshop.save
      respond_to do |format|
        format.html {edit_mode_workshop_path(@workshop)}
        format.js
      end
    end
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :duration, :image, :content, :content_type)
  end
end
