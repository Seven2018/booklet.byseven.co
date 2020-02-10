class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy]

  def index
    # Index with 'search' option and global visibility for SEVEN Users
    if current_user.access_level == 'Super Admin'
      @trainings = policy_scope(Training)
      if params[:search]
        @trainings = ((Training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (Training.joins(:company).where("lower(companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @trainings = policy_scope(Training)
      @trainings = Training.where(company: current_user.company.id)
      if params[:search]
        @trainings = @training.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      end
    end
  end

  def show
    authorize @training
    @training_workshop = TrainingWorkshop.new
    ['Super Admin', 'Admin', 'HR'].include?(current_user.access_level) ? @teams = Team.where(company_id: current_user.company_id) : @teams = current_user.teams
    @users = User.where(company_id: current_user.company_id)
  end

  def new
    @training = Training.new
    authorize @training
  end

  def create
    @training_program = TrainingProgram.find(params[:training_program_id])
    @training = Training.new(title: params[:training][:title], description: @training_program.description, participant_number: params[:training][:participant_number].to_i, image: @training_program.image, training_program_id: @training_program.id, company_id: current_user.company.id)
    authorize @training
    if @training.save
      @training_program.program_workshops.each do |program_workshop|
        new_training_workshop = TrainingWorkshop.create(program_workshop.workshop.attributes.except("id", "created_at", "updated_at", "author_id"))
        new_training_workshop.update(training_id: @training.id, workshop_id: program_workshop.workshop_id, date: Date.today, starts_at: Time.now, ends_at: Time.now)
        team_ids = params[:training_workshop][:team_ids].drop(1).map(&:to_i)
        team_ids.each do |ind|
          TeamWorkshop.create(team_id: ind, training_workshop_id: new_training_workshop.id)
          Team.find(ind).users.each do |user|
            Attendee.create(user_id: user.id, training_workshop_id: new_training_workshop.id, status: 'Invited')
          end
        end
        program_workshop.workshop.workshop_mods.each do |workshop_mod|
          new_training_workshop_mod = TrainingWorkshopMod.create(mod_id: workshop_mod.mod_id, training_workshop_id: new_training_workshop.id)
        end
      end
      redirect_to training_path(@training)
    else
      render :new
    end
  end

  def edit
    authorize @training
  end

  def update
    authorize @training
    @training.update(training_params)
    if @training.save
      redirect_to training_path(@training)
    else
      render :edit
    end
  end

  def destroy
    @training.destroy
    authorize @training
    redirect_to trainings_path
  end

  private

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:title, :description, :participant_number, :image)
  end
end
