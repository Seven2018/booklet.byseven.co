module Companies::Applications

  APPLICATIONS = {
    interviews: {
      name: 'Interviews',
      link: :my_interviews_path,
      icon: 'fluent:chat-multiple-24-filled',
      color: 'bkt-blue',
      perso: 'My interviews',
      team: 'My team interviews',
      link_team: :my_team_interviews_path
    },
    trainings: {
      name: 'Trainings',
      link: :my_trainings_path,
      icon: 'ion:school',
      color: 'bkt-orange',
      perso: 'My trainings',
      team: 'My team trainings',
      link_team: :my_team_trainings_path
    }
  }

  def clear_applications_params
    applications.reject! &:blank?
  end

  def active_applications
    applications.map{ |x| APPLICATIONS[x.to_sym]}
  end
end
