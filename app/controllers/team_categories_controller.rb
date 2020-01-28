class TeamCategoriesController < ApplicationController
  def create
    @team = Team.find(params[:team_id])
    @team_category = TeamCategory.new
    authorize @team_category
    # Links Team to Categories through joined table
    array = params[:team][:category_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if TeamCategory.where(team_id: @team.id, category_id: ind).empty?
        TeamCategory.create(team_id: @team.id, category_id: ind)
      end
    end
    # Select all Categories whose checkbox is unchecked and destroy their TeamCategory, if existing
    (Category.ids - array).each do |ind|
      unless TeamCategory.where(team_id: @team.id, category_id: ind).empty?
        TeamCategory.where(team_id: @team.id, category_id: ind).first.destroy
      end
    end
    redirect_to team_path(@team)
  end
end
