puts 'Cleaning database...'
Company.destroy_all
Training.destroy_all
TrainingProgram.destroy_all
User.destroy_all
Category.destroy_all
Skill.destroy_all
puts 'Done !'

Company.create(name: 'SEVEN', address: '5 rue Moret', zipcode: '75011', city: 'Paris', logo: 'https://seven-builder.herokuapp.com/assets/logo-seven-navbar-51a163c33ccd651fbb26210144a68af7f941f90131d3a359d8e1cb59a24ac375.png')
Company.create(name: 'SIDE', address: '40 Rue de la Folie-Regnault', zipcode: '75011', city: 'Paris', logo: 'https://media.licdn.com/dms/image/C560BAQGT8iWKexGcEQ/company-logo_200_200/0?e=2159024400&v=beta&t=ebKa0z5yeofy6lQAnXOmlRZTSYy_RZcKfKiRU-ulauU')
Company.create(name: 'FOCAL', address: "108 Rue de l'Avenir", zipcode: '42350', city: 'La Talaudière', logo: 'http://www.auditorium-nantes.com/wp-content/uploads/2018/08/focal-logo.jpg')

User.create(firstname: "Brice", lastname: "Chapuis", company_id: 1, email: "brice.chapuis@byseven.co", password: "tititoto", access_level: "Super Admin", gender: 'M', picture: 'https://media-exp1.licdn.com/dms/image/C4D03AQH76liGuqaaMA/profile-displayphoto-shrink_200_200/0?e=1583971200&v=beta&t=sXSYg68rJ2YBIzs5NrgrgJZf_CkmdMkiuIEuZ2nRU0A')
User.create(firstname: "Yahya", lastname: "Fallah", company_id: 1, email: "yahya.fallah@byseven.co", password: "tititoto", access_level: "Super Admin", gender: 'M', picture: 'https://media-exp1.licdn.com/dms/image/C5603AQFc5Cf9X4gL_w/profile-displayphoto-shrink_200_200/0?e=1585180800&v=beta&t=eJBIoMSgMxXKenQr7PrWixQSFBpIvcjhme-cQ5hjOm4')
User.create(firstname: "Jorick", lastname: "Roustan", company_id: 1, email: "jorick.roustan@byseven.co", password: "tititoto", access_level: "Manager", gender: 'M', picture: 'http://static8.viadeo-static.com/_Z-gjrDmn0yPKoiw9P481xLMzs0=/300x300/member/00223346scu6m79w%3Fts%3D1449006810000')
User.create(firstname: "Mathilde", lastname: "Meurer", company_id: 1, email: "mathilde.meurer@byseven.co", password: "tititoto", access_level: "HR", gender: 'F', picture: 'https://www.tedxbordeaux.com/wp-content/uploads/2018/07/equipe_mathilde_meurer.jpg')
User.create(firstname: "Camille", lastname: "Briand", company_id: 1, email: "camille.briand@byseven.co", password: "tititoto", access_level: "Employee", gender: 'F', picture: 'https://media-exp1.licdn.com/dms/image/C4D03AQGVTVVGpfqGXw/profile-displayphoto-shrink_200_200/0?e=1585785600&v=beta&t=Eev63R-VlwxDKXjhXAfLTCUDXb5PhJj9FV_zaOr-_g0')

Team.create(team_name: 'Team SEVEN', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBnUro-wUXAyxHcFgUpyE3mYacHTifjn1-7dxonThmaWdMOoq8Mw&s', company_id: 1)

Category.create(title: 'Négociation', description: "L'art de calmer sa femme.", company_id: 1)
Category.create(title: 'Business Development', description: "L'art de trouver des clients.", company_id: 1)

TrainingProgram.create(title: 'Négociation', company_id: 1, description: 'Apprendre à négocier en finesse.', participant_number: 10, image: 'https://images.unsplash.com/photo-1467664631004-58beab1ece0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80')

Workshop.create(title: 'Trust Challenge', company_id: 1, duration: 60, workshop_type: 'Synchronous', description: 'Blah blahblah', image: 'https://images.unsplash.com/photo-1551730459-92db2a308d6a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80')
Workshop.create(title: 'Intelligence économique', company_id: 1, duration: 90, workshop_type: 'Asynchronous', description: 'Analyse et influence', image: 'https://images.unsplash.com/photo-1507007246334-2a2ec227f2e9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80')

ProgramWorkshop.create(training_program_id: 1, workshop_id: 1, position: 1)
ProgramWorkshop.create(training_program_id: 1, workshop_id: 2, position: 2)

SkillGroup.create(title: 'Code')
SkillGroup.create(title: 'Sales')

Skill.create(title: 'Ruby', description: 'Maitrise de Ruby on Rails', skill_group_id: 1)
Skill.create(title: 'HTML/CSS', description: 'Talent de Front-end Developper', skill_group_id: 1)
Skill.create(title: 'Vente à domicile', description: '', skill_group_id: 2)
