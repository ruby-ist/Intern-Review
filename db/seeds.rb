# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin.destroy_all
# Trainer.destroy_all
#
# admin = Admin.create!
#
# trainer_ids = (1..3).map do
# 	Trainer.create!(admin: admin).id
# end

# intern_ids = (1..8).map do
# 	Intern.create!(technology: "Ruby on Rails").id
# end

# intern_ids = [6,7,8,9,10,11,12,13]
#
# Account.create!(
# 	[
		# {
		# 	name: "Aneesh",
		# 	email: "aneesh@rently.com",
		# 	password: "1234567",
		# 	password_confirmation: "1234567",
		# 	accountable_type: "Admin",
		# 	accountable_id: admin.id
		# },
		#
		# {
		# 	name: "Guna",
		# 	email: "guna@rently.com",
		# 	password: "1234567",
		# 	password_confirmation: "1234567",
		# 	accountable_type: "Trainer",
		# 	accountable_id: trainer_ids.shift
		# },
		#
		# {
		# 	name: "Priya",
		# 	email: "priya@rently.com",
		# 	password: "1234567",
		# 	password_confirmation: "1234567",
		# 	accountable_type: "Trainer",
		# 	accountable_id: trainer_ids.shift
		# },
		#
		# {
		# 	name: "Ramanan",
		# 	email: "ramanan@rently.com",
		# 	password: "1234567",
		# 	password_confirmation: "1234567",
		# 	accountable_type: "Trainer",
		# 	accountable_id: trainer_ids.shift
		# },

# 		{
# 			name: "mitra",
# 			email: "mitra@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "dhanushya",
# 			email: "dhanushya@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "alisha",
# 			email: "alisha@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "mugil",
# 			email: "mugil@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "hari",
# 			email: "hari@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "bala",
# 			email: "bala@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "gowtham",
# 			email: "gowtham@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
#
# 		{
# 			name: "raagav",
# 			email: "raagav@rently.com",
# 			password: "1234567",
# 			password_confirmation: "1234567",
# 			accountable_type: "Intern",
# 			accountable_id: intern_ids.shift
# 		},
# 	]
# )

# guna = Trainer.find 2
# guna.interns << Intern.find(1)
# guna.interns << Intern.find(6)
# guna.interns << Intern.find(7)
#
# priya = Trainer.find 3
# priya.interns << Intern.find(8)
# priya.interns << Intern.find(9)
# priya.interns << Intern.find(10)
#
# ramanan = Trainer.find 4
# ramanan.interns << Intern.find(11)
# ramanan.interns << Intern.find(12)
# ramanan.interns << Intern.find(13)
#
# Trainer.all.each do |trainer|
# 	trainer.courses << Course.first
# end
#
# Intern.all.each do |intern|
# 	next if intern.id == 1
# 	intern.courses << Course.first
# end
#
# trainer = Trainer.create!(admin_id: 3)
#
# Account.create!(name: "shanmugha",
# 				email: "shanmugha@rently.com",
# 				password: "1234567",
# 				password_confirmation: "1234567",
# 				accountable_id: trainer.id,
# 				accountable_type: "Trainer")
#
# Trainer.update_all(course_id: 1)

# Batch.create!(name: "Team guna", admin_id: 3)
# Batch.create!(name: "Team Priya", admin_id: 3)
# Batch.create!(name: "Team Ramanan", admin_id: 3)
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?