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
        ProgramWorkshop.create(training_program_id: @training_program.id, workshop_id: ind, position: ProgramWorkshop.where(training_program_id: @training_program.id).count + 1)
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

  def move_up
    @program_workshop = ProgramWorkshop.find(params[:program_workshop_id])
    authorize @program_workshop
    @training_program = @program_workshop.training_program
    unless @program_workshop.position == 1
      previous_workshop = @training_program.program_workshops.where(position: @program_workshop.position - 1).first
      previous_workshop.update(position: @program_workshop.position)
      @program_workshop.update(position: (@program_workshop.position - 1))
    end
    @program_workshop.save
    respond_to do |format|
      format.html {redirect_to training_program_path(@program_workshop.training_program)}
      format.js
    end
  end

  def move_down
    @program_workshop = ProgramWorkshop.find(params[:program_workshop_id])
    authorize @program_workshop
    @training_program = @program_workshop.training_program
    unless @program_workshop.position == @training_program.program_workshops.count
      next_workshop = @training_program.program_workshops.where(position: @program_workshop.position + 1).first
      next_workshop.update(position: @program_workshop.position)
      @program_workshop.update(position: (@program_workshop.position + 1))
    end
    @program_workshop.save
    respond_to do |format|
      format.html {redirect_to training_program_path(@program_workshop.training_program)}
      format.js
    end
  end
end
