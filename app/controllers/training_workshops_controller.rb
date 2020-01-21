class TrainingWorkshopsController < ApplicationController
  # Allows management of TrainingWorkshops through a checkbox collection
  def create
    @training_workshop = TrainingWorkshop.new
    authorize @training_workshop
    @training = Training.find(params[:training_id])
    # Select all Workshops whose checkbox is checked and create a TrainingWorkshop
    array = params[:training][:workshop_ids].uniq.drop(1).map(&:to_i)
    array.each do |ind|
      if TrainingWorkshop.where(training_id: @training.id, workshop_id: ind).empty?
        TrainingWorkshop.create(title: @training.title, training_id: @training.id, workshop_id: ind)
      end
    end
    # Select all Workshops whose checkbox is unchecked and destroy their TrainingWorkshop, if existing
    (Workshop.ids - array).each do |ind|
      unless TrainingWorkshop.where(training_id: @training.id, workshop_id: ind).empty?
        TrainingWorkshop.where(training_id: @training.id, workshop_id: ind).first.destroy
      end
    end
    redirect_to training_path(@training)
  end

  def update
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    @training_workshop.update(training_workshop_params)
    redirect_to training_path(@training_workshop.training) if @training_workshop.save
  end

  def copy
    @training_workshop = TrainingWorkshop.find(params[:id])
    authorize @training_workshop
    new_training_workshop = TrainingWorkshop.new(@training_workshop.attributes.except("id", "created_at", "updated_at"))
    new_training_workshop.title = params[:copy][:title]
    new_training_workshop.date = params[:copy][:date]
    redirect_to training_path(@training_workshop.training) if new_training_workshop.save
  end

  private

  def training_workshop_params
    params.require(:training_workshop).permit(:title, :date, :start_time, :end_time)
  end
end
