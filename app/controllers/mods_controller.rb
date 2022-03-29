class ModsController < ApplicationController
  before_action :set_mod, only: [:update, :duplicate, :destroy, :move_up, :move_down]
  helper VideoHelper

  # Create mod (contents/edit_mode)
  def create
    @new_mod = Mod.new(mod_params)
    authorize @new_mod
    @new_mod.company_id = current_user.company_id
    content_id = params.dig(:mod, :content_id)

    if content_id.present?
      @content = Content.find(content_id)
    else
      @content = Workshop.find(params.dig(:mod, :workshop_id))
    end

    target_position = params.dig(:mod, :position).to_i + 1
    mods = @content.mods.order(position: :asc)

    @new_mod.workshop_id = @content.id unless content_id.present?
    @new_mod.mod_type = params.dig(:mod, :mod_type)

    i = target_position
    mods.where('position >= ?', target_position).each do |mod|
      mod.update position: i + 1
      i += 1
    end

    @new_mod.position = target_position

    @new_mod.save
    @content.update(duration: @content.mods.map(&:duration).sum)

    respond_to do |format|
      format.html {content_path(@content)}
      format.js
    end
  end

  # Duplicate mod(contents/edit_mode)
  def duplicate
    authorize @module
    new_mod = Mod.new(@module.attributes.except("id", "created_at", "updated_at"))
    if new_mod.content_id.present?
      new_mod.position = new_mod.content.mods.count + 1
    else
      new_mod.position = new_mod.workshop.mods.count + 1
    end
    new_mod.save
    respond_to do |format|
      format.js
    end
  end

  # Update mod attributes (contents/edit_mode)
  def update
    authorize @module
    @module.update(mod_params)

    @module.save
    @content.update(duration: @content.mods.map(&:duration).sum)

    respond_to do |format|
      format.html {redirect_to edit_content_path(@content)}
      format.js
    end
  end

  # Delete mod (contents/edit_mode)
  def destroy
    authorize @module
    @module.destroy

    i = 1
    @content.mods.order(position: :asc).each do |mod|
      mod.update(position: i)
      i += 1
    end

    @content.update(duration: @content.mods.map(&:duration).sum)

    respond_to do |format|
      format.js
    end
  end

  # Change mod position (contents/edit_mode)
  def move_up
    skip_authorization
    position = @module.position
    @previous_module = @content.mods.find_by(position: position - 1)
    @previous_module.update(position: position)
    @module.update(position: position - 1)
    respond_to do |format|
      format.html {redirect_to content_path(@module.content)}
      format.js
    end
  end

  # Change mod position (contents/edit_mode)
  def move_down
    skip_authorization
    position = @module.position
    @next_module = @content.mods.find_by(position: position + 1)
    @next_module.update(position: position)
    @module.update(position: position + 1)
    respond_to do |format|
      format.html {redirect_to content_path(@module.content)}
      format.js
    end
  end

  #######################

  private

  def set_mod
    @module = Mod.find(params[:id])
    @content = @module.content.presence || @module.workshop
  end

  def mod_params
    params.require(:mod).permit(:title, :text, :link, :document, :video, :image, :mod_type, :duration, :content_id, :workshop_id, :position)
  end
end
