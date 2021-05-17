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

  def create
    @module = Mod.new(mod_params)
    authorize @module
    @module.document = params[:mod][:document]&.gsub(/edit/, 'present')
    @module.document = '' if @module.document == nil
    @module.company_id = current_user.company_id
    if @module.save
      if params[:content_id].present?
        content = Content.find(params[:content_id])
        ContentMod.create(mod_id: @module.id, content_id: content.id, position: ContentMod.where(content_id: params[:content_id]).count + 1)
        redirect_to content_path(content)
      elsif params[:training_content_id].present?
        training_content = Session.find(params[:training_content_id])
        SessionMod.create(mod_id: @module.id, training_content_id: training_content.id, position: SessionMod.where(training_content_id: params[:training_content_id]).count + 1)
        redirect_to training_content_path(training_content)
      end
    end
  end

  def create_mod
    @new_mod = Mod.new(title: params[:new_mod][:title], duration: params[:new_mod][:duration].to_i, document: params[:new_mod][:document], media: params[:new_mod][:media], content: params[:new_mod][:content], company_id: current_user.company_id)
    skip_authorization
    @new_content = Content.find(params[:new_mod][:content_id].to_i)
    if @new_mod.save
      ContentMod.create(content_id: @new_content.id, mod_id: @new_mod.id)
    end
    respond_to do |format|
      format.html {redirect_to new_content_path}
      format.js
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
    @content = Content.find(params[:content_id])
    i = 1
    @content.content_mods.order(position: :asc).each do |content_mod|
      content_mod.update(position: i)
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
