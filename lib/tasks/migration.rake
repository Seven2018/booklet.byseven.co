namespace :migration do
  desc "adapt v1 db to v2 db"
  task v1_v2: :environment do
    # Se débarasse des access_levels 'light'
    User.where(access_level: 'Manager-light').update_all access_level: 'Manager'
    User.where(access_level: 'HR-light').update_all access_level: 'HR'
    # Les owners des Campaigns existantes deviennent les interviewers de chaque interviews.
    # Interview.all.each{|x| x.update interviewer_id: x.campaign.owner_id}
    # Les interviews avec label 'Simple' ont maintenant le label 'Manager'
    Interview.where(label: 'Simple').update_all label: 'Manager'
    # Le paramètre qui définit une campaign 'crossed' est transféré au template utilisé
    Interview.where(label: 'Crossed').each{|x| x.interview_form.update(answerable_by: 'both', cross: true)}
    # Les templates pour les campaigns 'simple' sont answerable_by manager
    def make_answerable_by_manager(interview_form)
      answerable_by = 'manager'
      interview_form.update answerable_by: answerable_by
      interview_form.interview_questions.update_all(visible_for: answerable_by)
      interview_form.interview_questions.where(required: true).update_all(required_for: answerable_by)
    end
    InterviewForm.where(cross: false).each do |template|
      make_answerable_by_manager(template)
    end
    # Transfert des données de l'attribut required (boolean) vers required_for (enum)
    InterviewQuestion.where(required: true, visible_for: 'all').update_all required_for: 'all'
    InterviewQuestion.where(required: true, visible_for: 'manager').update_all required_for: 'manager'
    InterviewQuestion.where(required: true, visible_for: 'employee').update_all required_for: 'employee'
    InterviewQuestion.where(required: false).update_all required_for: 'none'

    Campaign.all.update_all(campaign_type: :one_to_one)
    # forcing these two interview form to be answerable by manager because it uses 2 template(simple and cross) on v1
    InterviewForm.where(id: [270, 221, 210]).each do |interview_form|
      make_answerable_by_manager(interview_form)
    end
  end

end
