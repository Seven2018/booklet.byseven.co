class WorkshopCategoriesController < ApplicationController
  def create
    @workshop = Workshop.find(params[:workshop_id])
    @workshop_category = WorkshopCategory.new
    authorize @workshop_category
    # Links Workshop to Categories through joined table
    array = params[:workshop][:category_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).empty?
        WorkshopCategory.create(workshop_id: @workshop.id, category_id: ind)
      end
    end
    # Select all Categories whose checkbox is unchecked and destroy their WorkshopCategory, if existing
    (Category.ids - array).each do |ind|
      unless WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).empty?
        WorkshopCategory.where(workshop_id: @workshop.id, category_id: ind).first.destroy
      end
    end
    redirect_to workshop_path(@workshop)
  end
end
