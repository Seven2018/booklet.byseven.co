class ProgramWorkshopsController < ApplicationController
  # Allows management of ProgramWorkshops through a checkbox collection
  def create
    @program_workshop = ProgramWorkshop.new
    authorize @program_workshop
    @training_program = TrainingProgram.find(params[:training_program_id])
    # Select all Workshops whose checkbox is checked and create a ProgramWorkshop
    array = params[:training_program][:workshop_ids].uniq.drop(1).map(&:to_i)
    array.each do |ind|
      if ProgramWorkshop.where(training_program_id: @training_program.id, workshop_id: ind).empty?
        ProgramWorkshop.create(training_program_id: @training_program.id, workshop_id: ind)
      end
    end
    # Select all Workshops whose checkbox is unchecked and destroy their ProgramWorkshop, if existing
    (Workshop.ids - array).each do |ind|
      unless ProgramWorkshop.where(training_program_id: @training_program.id, workshop_id: ind).empty?
        ProgramWorkshop.where(training_program_id: @training_program.id, workshop_id: ind).first.destroy
      end
    end
    redirect_to training_program_path(@training_program)
  end
end
