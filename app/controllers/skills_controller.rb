class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  # Index with "search" option
  def index
    params[:search] ? @skills = policy_scope(Skill).where("lower(title) LIKE ?", "%#{params[:search][:title].downcase}%").order(title: :asc) : @skills = policy_scope(Skill).order(title: :asc)
  end

  def show
    authorize @skill
  end

  def new
    @skill = Skill.new
    authorize @skill
  end

  def create
    @skill = Skill.new(skill_params)
    authorize @skill
    @skill.save ? (redirect_to skill_path(@skill)) : (render :new)
  end

  def edit
    authorize @skill
  end

  def update
    authorize @skill
    @skill.update(skill_params)
    @skill.save ? (redirect_to skill_path(@skill)) : (render '_edit')
  end

  def destroy
    @skill.destroy
    authorize @skill
    redirect_to skills_path
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:title, :description)
  end
end

