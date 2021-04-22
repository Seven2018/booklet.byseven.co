class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]

  def show
    authorize @tag
  end

  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    @tag.company_id = current_user.company_id
    if @tag.save
      redirect_back(fallback_location: root_path)
    else
      raise
    end
  end

  def update
    authorize @tag
    @tag.update(tag_params)
    @tag.company_id = current_user.company_id
    if @tag.save
      redirect_to tag_path(@tag)
    else
      raise
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:tag_name, :image, :tag_category_id)
  end
end
