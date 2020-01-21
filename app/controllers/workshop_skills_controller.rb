class WorkshopSkillsController < ApplicationController
  # Allows management of WorkshopSkills through a checkbox collection
  def create
    @workshop_skill = WorkshopSkill.new
    authorize @workshop_skill
    @workshop = Workshop.find(params[:workshop_id])
    # Select all Users whose checkbox is checked and create a WorkshopSkill
    array = params[:workshop][:skill_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if WorkshopSkill.where(workshop_id: @workshop.id, skill_id: ind).empty?
        WorkshopSkill.create(workshop_id: @workshop.id, skill_id: ind)
      end
    end
    # Select all Skills whose checkbox is unchecked and destroy their WorkshopSkill, if existing
    (Skill.ids - array).each do |ind|
      unless WorkshopSkill.where(workshop_id: @workshop.id, skill_id: ind).empty?
        WorkshopSkill.where(workshop_id: @workshop.id, skill_id: ind).first.destroy
      end
    end
    redirect_to workshop_path(@workshop)
  end
end
