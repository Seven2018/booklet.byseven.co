class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :training_workshop
  validates :training_workshop_id, uniqueness: { scope: :user_id }
  accepts_nested_attributes_for :user

  def mark_as_completed
    self.update(status: 'Completed')
    if self.save
      workshop = self.training_workshop.workshop
      workshop.skills.each do |skill|
        new_user_skill = UserSkill.create(user_id: self.user_id, skill_id: skill.id)
      end
    end
  end

  def mark_as_invited
    self.update(status: 'Invited')
  end
end
