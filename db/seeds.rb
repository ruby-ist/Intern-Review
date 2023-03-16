# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.destroy_all
Trainer.destroy_all

admin = Admin.create!

trainer_ids = (1..3).map do
	Trainer.create!(admin: admin).id
end

intern_ids = (1..8).map do
	Intern.create!(technology: "Ruby on Rails")
end

Account.create!(
	[
		{
			name: "Aneesh",
			email: "aneesh@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Admin",
			accountable_id: admin.id
		},

		{
			name: "Guna",
			email: "guna@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Trainer",
			accountable_id: trainer_ids.shift
		},

		{
			name: "Priya",
			email: "priya@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Trainer",
			accountable_id: trainer_ids.shift
		},

		{
			name: "Ramanan",
			email: "ramanan@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Trainer",
			accountable_id: trainer_ids.shift
		},

		{
			name: "mitra",
			email: "mitra@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "dhanushya",
			email: "dhanushya@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "alisha",
			email: "alisha@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "mugil",
			email: "mugil@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "hari",
			email: "hari@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "bala",
			email: "bala@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "gowtham",
			email: "gowtham@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},

		{
			name: "raagav",
			email: "raagav@rently.com",
			password: "1234567",
			password_confirmation: "1234567",
			accountable_type: "Intern",
			accountable_id: intern_ids.shift
		},
	]
)

guna = Trainer.find_by(name: "Guna")
guna.interns << Intern.find_by(name: "Sriram")
guna.interns << Intern.find_by(name: "mitra")
guna.interns << Intern.find_by(name: "alisha")

priya = Trainer.find_by(name: "Priya")
priya.interns << Intern.find_by(name: "dhanushya")
priya.interns << Intern.find_by(name: "mugil")
priya.interns << Intern.find_by(name: "hari")

ramanan = Trainer.find_by(name: "Ramanan")
ramanan.interns << Intern.find_by(name: "bala")
ramanan.interns << Intern.find_by(name: "gowtham")
ramanan.interns << Intern.find_by(name: "raagav")

Trainer.all.each do |trainer|
	trainer.courses << Course.first
end

Intern.all.each do |trainer|
	Intern.courses << Course.first
end