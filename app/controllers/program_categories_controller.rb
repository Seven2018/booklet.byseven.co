class ProgramCategoriesController < ApplicationController
  def create
    @training_program = TrainingProgram.find(params[:training_program_id])
    @program_category = ProgramCategory.new
    authorize @program_category
    # Links TrainingProgram to Categories through joined table
    array = params[:training_program][:category_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if ProgramCategory.where(training_program_id: @training_program.id, category_id: ind).empty?
        ProgramCategory.create(training_program_id: @training_program.id, category_id: ind)
      end
    end
    # Select all Categories whose checkbox is unchecked and destroy their ProgramCategory, if existing
    (Category.ids - array).each do |ind|
      unless ProgramCategory.where(training_program_id: @training_program.id, category_id: ind).empty?
        ProgramCategory.where(training_program_id: @training_program.id, category_id: ind).first.destroy
      end
    end
    redirect_to training_program_path(@training_program)
  end
end
