class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :update, :destroy]

  def show
    authorize @team
    @team_category = TeamCategory.new
  end

  def create
    @team = Team.new(team_params)
    authorize @team
    @team.company_id = current_user.company_id
    if @team.save
      redirect_back(fallback_location: root_path)
    else
      raise
    end
  end

  def update
    authorize @team
    @team.update(team_params)
    @team.company_id = current_user.company_id
    if @team.save
      redirect_to team_path(@team)
    else
      raise
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:team_name, :image)
  end
end
