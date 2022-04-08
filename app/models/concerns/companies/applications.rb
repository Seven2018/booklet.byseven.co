module Companies::Applications

  APPLICATIONS = {
    interviews: {
      name: 'Interviews',
      link: :my_interviews_path,
      icon: 'fluent:chat-multiple-24-filled',
      color: 'bkt-blue'
    },
    trainings: {
      name: 'Trainings',
      link: :my_trainings_path,
      icon: 'ion:school',
      color: 'bkt-orange'
    }
  }

  def update_application(name, boolean)
    applications[name] = boolean
    update_column(:applications, applications)
  end

  def active_applications
    applications.symbolize_keys.map{ |key, active| APPLICATIONS[key] if active }.compact
  end
end
