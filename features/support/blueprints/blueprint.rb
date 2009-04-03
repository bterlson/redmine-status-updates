Sham.mail { Faker::Internet.email }
Sham.firstname { Faker::Name.first_name }
Sham.lastname { Faker::Name.last_name }
Sham.login { Faker::Internet.user_name }

User.blueprint do
  mail
  firstname
  lastname
  login
end
