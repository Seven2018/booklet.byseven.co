class TrainingProgramsController < ApplicationController
  before_action :set_training_program, only: [:show, :edit, :update, :destroy]

  def index
    # Index with 'search' option and global visibility for SEVEN Users
    if current_user.access_level == 'Super Admin'
      @training_programs = policy_scope(TrainingProgram)
      if params[:search]
        @training_programs = ((TrainingProgram.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)) + (TrainingProgram.joins(:company).where("lower(companies.name) LIKE ?", "%#{params[:search][:title].downcase}%"))).flatten(1).uniq
      end
    # Index for other Users, with visibility limited to programs proposed by their company only
    else
      @training_programs = policy_scope(TrainingProgram)
      @training_programs = TrainingProgram.joins(:company).where(companies: { name: current_user.company.name })
      if params[:search]
        @training_programs = @training_programs.where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc)
      end
    end
    @training = Training.new
  end

  def show
    authorize @training_program
    @program_workshop = ProgramWorkshop.new
  end

  def new
    @training_program = TrainingProgram.new
    authorize @training_program
  end

  def create
    @training_program = TrainingProgram.new(training_program_params)
    authorize @training_program
    @training_program.company_id = current_user.company.id

    if @training_program.save
      redirect_to training_program_path(@training_program)
    else
      render :new
    end
  end

  def edit
    authorize @training_program
  end

  def update
    authorize @training_program
    @training_program.update(training_program_params)
    if @training_program.save
      redirect_to training_program_path(@training_program)
    else
      render :edit
    end
  end

  def destroy
    @training_program.destroy
    authorize @training_program
    redirect_to training_programs_path
  end

  def filter
    @training_programs = TrainingProgram.where(company_id: current_user.company.id)
    authorize @training_programs
    category_ids = params[:workshop][:category_ids].drop(1).map(&:to_i)
    redirect_to training_programs_path(filter: category_ids)
  end

  private

  def set_training_program
    @training_program = TrainingProgram.find(params[:id])
  end

  def training_program_params
    params.require(:training_program).permit(:title, :description, :participant_number, :image)
  end
end
