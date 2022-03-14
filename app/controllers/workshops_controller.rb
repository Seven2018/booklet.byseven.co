class WorkshopsController < ApplicationController
  before_action :set_workshop, only: [:show, :edit, :update, :complete_workshop]
  before_action :show_navbar_training

  # Show workshop view_mode
  def show
    authorize @workshop
    workshop_completed?
  end

  # Show workshop edit_mode
  def edit
    authorize @workshop

    reorder_mods
  end

  # Update workshop attributes
  def update
    authorize @workshop
    @workshop.update(workshop_params)
    reorder_mods

    if @workshop.save
      respond_to do |format|
        format.html {edit_mode_workshop_path(@workshop)}
        format.js
      end
    end
  end

  def complete_workshop
    authorize @workshop

    Attendee.where(session: @workshop.sessions.ids, user_id: params[:user_id]).update_all status: params[:status]

    workshop_completed?

    respond_to do |format|
      format.js
    end
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end

  def workshop_completed?
    @workshop_completed =
      Attendee.where(user: current_user, session: @workshop.sessions.ids).map(&:status).uniq.join == 'Completed'
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :duration, :image, :content, :content_type)
  end

  def reorder_mods
    mods = @workshop.mods.order(position: :asc)
    if mods.map(&:position) != (1..mods.count).to_a
      i = 1
      mods.each{|x| x.update position: i; x.save; i += 1;}
    end
  end
end
