class UserTeamsController < ApplicationController
  def create
    @team = Team.find(params[:team_id])
    @user_team = UserTeam.new
    authorize @user_team
    # Links User to UserTeams through joined table
    array = params[:team][:user_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if UserTeam.where(team_id: @team.id, user_id: ind).empty?
        UserTeam.create(team_id: @team.id, user_id: ind)
      end
    end
    # Select all Users whose checkbox is unchecked and destroy their UserTeam, if existing
    (User.where(company_id: current_user.company_id).ids - array).each do |ind|
      unless UserTeam.where(team_id: @team.id, user_id: ind).empty?
        UserTeam.where(team_id: @team.id, user_id: ind).first.destroy
      end
    end
    redirect_to team_path(@team)
  end
end
