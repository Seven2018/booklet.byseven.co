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

  def update_application(name, boolean)
    applications[name] = boolean
    update_column(:applications, applications)
  end

  def active_applications
    applications.map{ |key, active| APPLICATIONS[key] if active }.compact
  end
end
