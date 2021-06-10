class ModsController < ApplicationController
  before_action :set_mod, only: [:show, :update, :destroy, :move_up, :move_down]
  helper VideoHelper

  def show
    authorize @module
  end

  def new
    @module = Mod.new
    authorize @module
    if params[:content_id].present?
      @content = Content.find(params[:content_id])
    elsif params[:training_content_id].present?
      @training_content = Session.find(params[:training_content_id])
    end
  end

  def create
    @new_mod = Mod.new(mod_params)
    authorize @new_mod
    @content = Content.find(params[:mod][:content_id])
    @new_mod.company_id = current_user.company_id
    @new_mod.content_id = params[:mod][:content_id]
    @new_mod.mod_type = params[:mod][:mod_type]
    @new_mod.position = @content.mods.order(position: :asc).count + 1
    if @new_mod.save
      @content.update(duration: @content.mods.map(&:duration).sum)
      respond_to do |format|
        format.html {redirect_to content_path(@content)}
        format.js
      end
    end
  end

  def update_mod
    skip_authorization
    respond_to do |format|
      format.html {redirect_to new_content_path}
      format.js
    end
  end

  def update
    authorize @module
    @content = @module.content
    @module.update(mod_params)
    if @module.save
      @content.update(duration: @content.mods.map(&:duration).sum)
      respond_to do |format|
        format.html {redirect_to content_path(@content)}
        format.js
      end
    end
  end

  def destroy
    authorize @module
    @module.destroy
    @content = @module.content
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

  def move_up
    skip_authorization
    @content = @module.content
    position = @module.position
    @previous_module = @content.mods.find_by(position: position - 1)
    @previous_module.update(position: position)
    @module.update(position: position - 1)
    respond_to do |format|
      format.html {redirect_to content_path(@module.content)}
      format.js
    end
  end

  def move_down
    skip_authorization
    @content = @module.content
    position = @module.position
    @next_module = @content.mods.find_by(position: position + 1)
    @next_module.update(position: position)
    @module.update(position: position + 1)
    respond_to do |format|
      format.html {redirect_to content_path(@module.content)}
      format.js
    end
  end

  private

  def set_mod
    @module = Mod.find(params[:id])
  end

  def mod_params
    params.require(:mod).permit(:title, :position, :duration, :content_id, :document, :video, :image, :mod_type, :text)
  end
end
