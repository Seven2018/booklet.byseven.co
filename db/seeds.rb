puts 'Cleaning database...'
User.destroy_all
Category.destroy_all
Company.destroy_all
Skill.destroy_all
puts 'Done !'

Company.create(name: 'SEVEN', address: '5 rue Moret', zipcode: '75011', city: 'Paris', logo: 'https://seven-builder.herokuapp.com/assets/logo-seven-navbar-51a163c33ccd651fbb26210144a68af7f941f90131d3a359d8e1cb59a24ac375.png', siret: '80396439400024', auth_token: rand(36**12).to_s(36))
Company.create(name: 'BIG MAMMA', address: "28 rue d'Aboukir", zipcode: '75002', city: 'Paris', logo: 'https://media.glassdoor.com/sqll/1563896/big-mamma-groupe-squarelogo-1511525722768.png', siret: '83850177300017', auth_token: rand(36**12).to_s(36))

User.create(firstname: "Brice", lastname: "Chapuis", company_id: 1, email: "brice.chapuis@byseven.co", password: 'Seven2021', access_level_int: :admin, gender: 'M', picture: 'https://media-exp1.licdn.com/dms/image/C4D03AQH76liGuqaaMA/profile-displayphoto-shrink_200_200/0?e=1583971200&v=beta&t=sXSYg68rJ2YBIzs5NrgrgJZf_CkmdMkiuIEuZ2nRU0A')
User.create(firstname: "Hedi", lastname: "Mestiri", company_id: 1, email: "hedi.mestiri@byseven.co", password: 'Seven2021', access_level_int: :hr, gender: 'M', picture: '')
User.create(firstname: "Yahya", lastname: "Fallah", company_id: 1, email: "yahya.fallah@byseven.co", password: 'Seven2021', access_level_int: :hr, gender: 'M', picture: 'https://media-exp1.licdn.com/dms/image/C5603AQFc5Cf9X4gL_w/profile-displayphoto-shrink_200_200/0?e=1585180800&v=beta&t=eJBIoMSgMxXKenQr7PrWixQSFBpIvcjhme-cQ5hjOm4')
User.create(firstname: "Jorick", lastname: "Roustan", company_id: 1, email: "jorick.roustan@byseven.co", password: 'Seven2021', access_level_int: :manager, gender: 'M', picture: 'http://static8.viadeo-static.com/_Z-gjrDmn0yPKoiw9P481xLMzs0=/300x300/member/00223346scu6m79w%3Fts%3D1449006810000')
User.create(firstname: "Mathilde", lastname: "Meurer", company_id: 1, email: "mathilde.meurer@byseven.co", password: 'Seven2021', access_level_int: :hr, gender: 'F', picture: 'https://www.tedxbordeaux.com/wp-content/uploads/2018/07/equipe_mathilde_meurer.jpg')
User.create(firstname: "Marjorie", lastname: "Buisson", company_id: 2, email: "marjoriebuisson@gmail.com", password: 'BigMamma2021', access_level_int: :hr, gender: 'F', picture: 'https://pbs.twimg.com/profile_images/801444623302455297/lJ4dYiKX.jpg')

User.all.each do |user|
  user.update(authentication_token: Base64.encode64(user.email).gsub("\n","") + SecureRandom.hex(32))
end

#Tag.create(tag_name: 'Tag SEVEN', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBnUro-wUXAyxHcFgUpyE3mYacHTifjn1-7dxonThmaWdMOoq8Mw&s', company_id: 1)

# Category.create(title: 'Négociation', company_id: 1)
# Category.create(title: 'Business Development', company_id: 1)

#Content.create(title: 'Trust Challenge', company_id: 1, duration: 60, content_type: 'Synchronous', description: 'Blah blahblah', image: 'https://images.unsplash.com/photo-1551730459-92db2a308d6a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80', author_id: 2)
#Content.create(title: 'Intelligence économique', company_id: 1, duration: 90, content_type: 'Asynchronous', description: 'Analyse et influence', image: 'https://images.unsplash.com/photo-1507007246334-2a2ec227f2e9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80', author_id: 2)


#SkillGroup.create(title: 'Code')
#SkillGroup.create(title: 'Sales')

#Skill.create(title: 'Ruby', description: 'Maitrise de Ruby on Rails', skill_group_id: 1)
#Skill.create(title: 'HTML/CSS', description: 'Talent de Front-end Developper', skill_group_id: 1)
#Skill.create(title: 'Vente à domicile', description: '', skill_group_id: 2)

Folder.create(title: 'Devenir Directeur', company_id: 2)
Folder.create(title: 'Communication', company_id: 2)
Folder.create(title: 'Leadership', company_id: 2)
Folder.create(title: 'Les leviers de motivation', company_id: 2)

Content.create(title: "Communiquer efficacement", company_id: 2)
Content.create(title: "Loi de diffusion de l'innovation", company_id: 2)
Content.create(title: "Créer un climat de confiance", company_id: 2)
Content.create(title: "Etre inspiré et insprirant", company_id: 2)
Content.create(title: "Les lunettes de Bono", company_id: 2)
Content.create(title: "Moving Motivators", company_id: 2)

ContentFolderLink.create(content_id: 1, folder_id: 2)
ContentFolderLink.create(content_id: 2, folder_id: 2)
ContentFolderLink.create(content_id: 3, folder_id: 3)
ContentFolderLink.create(content_id: 4, folder_id: 3)
ContentFolderLink.create(content_id: 5, folder_id: 1)
ContentFolderLink.create(content_id: 6, folder_id: 4)

FolderLink.create(parent_id: 1, child_id: 2)
FolderLink.create(parent_id: 1, child_id: 3)
FolderLink.create(parent_id: 3, child_id: 4)
