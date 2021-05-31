class ModsController < ApplicationController
  before_action :set_mod, only: [:show, :update, :destroy]
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

  # def create
  #   @module = Mod.new(mod_params)
  #   authorize @module
  #   @module.document = params[:mod][:document]&.gsub(/edit/, 'present')
  #   @module.document = '' if @module.document == nil
  #   @module.company_id = current_user.company_id
  #   if @module.save
  #     if params[:content_id].present?
  #       content = Content.find(params[:content_id])
  #       ContentMod.create(mod_id: @module.id, content_id: content.id, position: ContentMod.where(content_id: params[:content_id]).count + 1)
  #       redirect_to content_path(content)
  #     elsif params[:training_content_id].present?
  #       training_content = Session.find(params[:training_content_id])
  #       SessionMod.create(mod_id: @module.id, training_content_id: training_content.id, position: SessionMod.where(training_content_id: params[:training_content_id]).count + 1)
  #       redirect_to training_content_path(training_content)
  #     end
  #   end
  # end

  def create
    @new_mod = Mod.new(mod_params)
    authorize @new_mod
    @content = Content.find(params[:mod][:content_id])
    @new_mod.company_id = current_user.company_id
    @new_mod.content_id = params[:mod][:content_id]
    @new_mod.mod_type = params[:mod][:mod_type]
    @new_mod.position = @content.mods.order(position: :asc).count + 1
    if @new_mod.save
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
    content = Content.find(params[:content_id]) if params[:content_id].present?
    @module.update(mod_params)
    if @module.save
      params[:content_id].present? ? (redirect_to content_path(content)) : (redirect_to mod_path(@module))
    else
      raise
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
    respond_to do |format|
      format.js
    end
  end

  private

  def set_mod
    @module = Mod.find(params[:id])
  end

  def mod_params
    params.require(:mod).permit(:title, :position, :content_id, :document, :video, :image, :mod_type, :text)
  end
end
