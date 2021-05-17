class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :session
  belongs_to :creator, class_name: 'User', optional: true
  validates :session_id, uniqueness: { scope: :user_id }

  def mark_as_completed
    self.update(status: 'Completed')
    if self.save
      content = self.training_content.content
      content.skills.each do |skill|
        new_user_skill = UserSkill.create(user_id: self.user_id, skill_id: skill.id)
      end
    end
  end

  def mark_as_invited
    self.update(status: 'Invited')
  end
end
