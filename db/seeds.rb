puts 'Cleaning database...'
Company.destroy_all
Training.destroy_all
TrainingProgram.destroy_all
User.destroy_all
Category.destroy_all
Skill.destroy_all
puts 'Done !'

puts 'Adding users...'
User.create(firstname: "Brice", lastname: "Chapuis", email: "brice.chapuis@byseven.co", password: "tititoto", access_level: "Super Admin", gender: 'M')
puts 'Done !'

puts 'Adding companies...'
Company.create(name: 'SIDE', address: '40 Rue de la Folie-Regnault', zipcode: '75011', city: 'Paris', logo: 'https://media.licdn.com/dms/image/C560BAQGT8iWKexGcEQ/company-logo_200_200/0?e=2159024400&v=beta&t=ebKa0z5yeofy6lQAnXOmlRZTSYy_RZcKfKiRU-ulauU')
puts 'Done !'

puts 'Adding Categories...'
Category.create(title: 'Négociation', description: "L'art de calmer sa femme.")
puts 'Done !'
