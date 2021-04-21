class WorkshopModsController < ApplicationController
  def create
    @workshop = Workshop.find(params[:workshop_id])
    @workshop_mod = WorkshopMod.new
    authorize @workshop_mod
    # Links Workshop to Mods through joined table
    array = params[:workshop][:mod_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if WorkshopMod.where(workshop_id: @workshop.id, mod_id: ind).empty?
        WorkshopMod.create(workshop_id: @workshop.id, mod_id: ind, position: @workshop.workshop_mods.count + 1)
      end
    end
    # Select all Categories whose checkbox is unchecked and destroy their WorkshopMod, if existing
    reorder = false
    (Mod.ids - array).each do |ind|
      workshop_mod = WorkshopMod.where(workshop_id: @workshop.id, mod_id: ind).first
      if workshop_mod.present? && workshop_mod&.mod&.mod_type != 'Assessment'
        WorkshopMod.where(workshop_id: @workshop.id, mod_id: ind).first.destroy
        reorder = true
      end
    end
    if reorder
      i = 1
      @workshop.workshop_mods.order(:position).each do |mod|
        mod.update(position: i)
        i += 1
      end
    end
    redirect_to workshop_path(@workshop)
  end

  def create_ajax
    @workshop = Workshop.find(params[:link_mod][:workshop_id])
    skip_authorization
    mods_list = params[:workshop][:mod_ids].reject{|x|x.empty?}.map{|x| x.to_i}
    mods_list.each do |mod_id|
      WorkshopMod.create(workshop_id: @workshop.id, mod_id: mod_id)
    end
    WorkshopMod.where(workshop_id: @workshop.id, mod_id: params[:link_mod][:workshop_list].split(' ').map{|c|c.to_i} - mods_list).each{|x| x.destroy}
    respond_to do |format|
      format.html {redirect_to new_workshop_path}
      format.js
    end
  end

  def move_up
    @workshop_mod = WorkshopMod.find(params[:id])
    authorize @workshop_mod
    @workshop = @workshop_mod.workshop
    unless @workshop_mod.position == 1
      previous_workshop_mod = @workshop.workshop_mods.where(position: @workshop_mod.position - 1).first
      previous_workshop_mod.update(position: @workshop_mod.position)
      @workshop_mod.update(position: (@workshop_mod.position - 1))
    end
    @workshop_mod.save
    respond_to do |format|
      format.html {redirect_to workshop_path(@workshop_mod.workshop)}
      format.js
    end
  end

  def move_down
    @workshop_mod = WorkshopMod.find(params[:id])
    authorize @workshop_mod
    @workshop = @workshop_mod.workshop
    unless @workshop_mod.position == @workshop.workshop_mods.count
      next_workshop_mod = @workshop.workshop_mods.where(position: @workshop_mod.position + 1).first
      next_workshop_mod.update(position: @workshop_mod.position)
      @workshop_mod.update(position: (@workshop_mod.position + 1))
    end
    @workshop_mod.save
    respond_to do |format|
      format.html {redirect_to workshop_path(@workshop_mod.workshop)}
      format.js
    end
  end
end
