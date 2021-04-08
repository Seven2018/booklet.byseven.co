class ModsController < ApplicationController
  before_action :set_mod, only: [:show, :update, :destroy]

  def show
    authorize @module
  end

  def new
    @module = Mod.new
    authorize @module
    if params[:workshop_id].present?
      @workshop = Workshop.find(params[:workshop_id])
    elsif params[:training_workshop_id].present?
      @training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    end
  end

  def create
    @module = Mod.new(mod_params)
    authorize @module
    @module.document = params[:mod][:document]&.gsub(/edit/, 'present')
    @module.company_id = current_user.company_id
    if @module.save
      if params[:workshop_id].present?
        workshop = Workshop.find(params[:workshop_id])
        WorkshopMod.create(mod_id: @module.id, workshop_id: workshop.id, position: WorkshopMod.where(workshop_id: params[:workshop_id]).count + 1)
        redirect_to workshop_path(workshop)
      elsif params[:training_workshop_id].present?
        training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
        TrainingWorkshopMod.create(mod_id: @module.id, training_workshop_id: training_workshop.id, position: TrainingWorkshopMod.where(training_workshop_id: params[:training_workshop_id]).count + 1)
        redirect_to training_workshop_path(training_workshop)
      end
    end
  end

  def update
    authorize @module
    workshop = Workshop.find(params[:workshop_id]) if params[:workshop_id].present?
    @module.update(mod_params)
    if @module.save
      params[:workshop_id].present? ? (redirect_to workshop_path(workshop)) : (redirect_to mod_path(@module))
    else
      raise
    end
  end

  def destroy
    authorize @module
    @module.destroy
    @workshop = Workshop.find(params[:workshop_id])
    i = 1
    @workshop.workshop_mods.order(position: :asc).each do |workshop_mod|
      workshop_mod.update(position: i)
      i += 1
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_mod
    @module = Mod.find(params[:id])
  end

  def mod_params
    params.require(:mod).permit(:title, :duration, :content, :document, :media)
  end
end
