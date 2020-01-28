class WorkshopModsController < ApplicationController
  def create
    @workshop = Workshop.find(params[:workshop_id])
    @workshop_mod = WorkshopMod.new
    authorize @workshop_mod
    # Links Workshop to Mods through joined table
    array = params[:workshop][:mod_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if WorkshopMod.where(workshop_id: @workshop.id, mod_id: ind).empty?
        WorkshopMod.create(workshop_id: @workshop.id, mod_id: ind)
      end
    end
    # Select all Categories whose checkbox is unchecked and destroy their WorkshopMod, if existing
    (Mod.ids - array).each do |ind|
      unless WorkshopMod.where(workshop_id: @workshop.id, mod_id: ind).empty?
        WorkshopMod.where(workshop_id: @workshop.id, mod_id: ind).first.destroy
      end
    end
    redirect_to workshop_path(@workshop)
  end
end
