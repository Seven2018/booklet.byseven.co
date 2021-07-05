class ContentSkillsController < ApplicationController

  # Allows management of ContentSkills through a checkbox collection (not used)
  def create
    @content_skill = ContentSkill.new
    authorize @content_skill
    @content = Content.find(params[:content_id])
    # Select all Users whose checkbox is checked and create a ContentSkill
    array = params[:content][:skill_ids].drop(1).map(&:to_i)
    array.each do |ind|
      if ContentSkill.where(content_id: @content.id, skill_id: ind).empty?
        ContentSkill.create(content_id: @content.id, skill_id: ind)
      end
    end
    # Select all Skills whose checkbox is unchecked and destroy their ContentSkill, if existing
    (Skill.ids - array).each do |ind|
      unless ContentSkill.where(content_id: @content.id, skill_id: ind).empty?
        ContentSkill.where(content_id: @content.id, skill_id: ind).first.destroy
      end
    end
    redirect_to content_path(@content)
  end
end
