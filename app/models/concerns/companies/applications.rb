module Companies::Applications

  APPLICATIONS = {
    interviews: {
      name: 'Interviews',
      link: :my_interviews_path,
      icon: 'fluent:chat-multiple-24-filled',
      color: 'bkt-blue',
      hex_color: '#3177B7',
      perso: 'My interviews',
      team: 'My team interviews',
      link_team: :my_team_interviews_path,
      teaser: 'Annual reviews, onboardings, discovery reports and many more are all processed here.'
    },
    trainings: {
      name: 'Trainings',
      link: :my_trainings_path,
      icon: 'ion:school',
      color: 'bkt-orange',
      hex_color: '#EF8C64',
      perso: 'My trainings',
      team: 'My team trainings',
      link_team: :my_team_trainings_path,
      teaser: 'Professionnal trainings, skill upgrades, and all kinds of contents in a single app.'
    },
    objectives: {
      name: 'Roadmaps',
      link: :objective_my_objectives_path,
      icon: 'fluent:target-arrow-20-filled',
      color: 'bkt-objective-blue',
      hex_color: '#5C95FF',
      perso: 'My objectives',
      team: 'My team objectives',
      link_team: :objective_my_team_objectives_path,
      teaser: 'View, create and update all your targets and team targets. Follow their completion here.'
    }
  }

  def clear_applications_params
    applications.reject! &:blank?
  end

  def active_applications
    applications.map{ |x| APPLICATIONS[x.to_sym]}
  end
end
