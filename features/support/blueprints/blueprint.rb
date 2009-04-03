Sham.mail { Faker::Internet.email }
Sham.firstname { Faker::Name.first_name }
Sham.lastname { Faker::Name.last_name }
Sham.login { Faker::Internet.user_name }
Sham.project_name { Faker::Company.name }
Sham.identifier { Faker::Internet.domain_word.downcase }
Sham.message { Faker::Company.bs }

# Redmine specific

User.blueprint do
  mail
  firstname
  lastname
  login
end

Project.blueprint do
  name { Sham.project_name }
  identifier
end

# Plugin specific 
Status.blueprint do
  user
  project
  message
end
