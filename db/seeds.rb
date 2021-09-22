# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create({
  first_name: 'Alex',
  last_name: 'Chaplinsky',
  email: 'alchaplinsky@gmail.com',
  password: Devise.friendly_token
})

i1 = Interest.create(name: 'Travel', user_id: user.id)
i2 = Interest.create(name: 'English', user_id: user.id)
i3 = Interest.create(name: 'Programming', user_id: user.id)

i1.submissions.create(text: 'Best time to visit Bali')
i1.submissions.create(text: 'US trip, California cities')

i2.submissions.create(text: 'Urban Dictionary')

i3.submissions.create(text: 'Learning Ruby')
