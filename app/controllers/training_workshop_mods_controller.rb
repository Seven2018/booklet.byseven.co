class TrainingWorkshopModsController < ApplicationController
  def create
    @training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    @training_workshop_mod = TrainingWorkshopMod.new
    authorize @training_workshop_mod
    # Links TrainingWorkshop to Mods through joined table
    array = params[:training_workshop][:mod_ids].drop(1).map(&:to_i)
    last_position = TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id)&.order(position: :asc)&.last&.position
    last_position = 1 unless last_position.present?
    array.each do |ind|
      if TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id, mod_id: ind).empty?
        TrainingWorkshopMod.create(training_workshop_id: @training_workshop.id, mod_id: ind, position: last_position)
      end
      last_position += 1
    end
    # Select all Categories whose checkbox is unchecked and destroy their TrainingWorkshopMod, if existing
    (Mod.ids - array).each do |ind|
      unless TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id, mod_id: ind).empty?
        TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id, mod_id: ind).first.destroy
      end
    end
    i = 1
    TrainingWorkshopMod.where(training_workshop_id: @training_workshop.id).order(position: :asc).each{|c| c.update(position: i); i += 1;}
    redirect_to training_workshop_path(@training_workshop)
  end
end
