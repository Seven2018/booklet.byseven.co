class TrainingWorkshopModsController < ApplicationController
  def create
    @training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    @training_workshop_mod = TrainingWorkshopMod.new
    authorize @training_workshop_mod
    # Links TrainingWorkshop to Mods through joined table
    array = params[:training_workshop][:mod_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id, mod_id: ind).empty?
        TrainingWorkshopMod.create(training_workshop_id: @training_workshop.id, mod_id: ind)
      end
    end
    # Select all Categories whose checkbox is unchecked and destroy their TrainingWorkshopMod, if existing
    (Mod.ids - array).each do |ind|
      unless TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id, mod_id: ind).empty?
        TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id, mod_id: ind).first.destroy
      end
    end
    redirect_to training_workshop_path(@training_workshop)
  end
end
