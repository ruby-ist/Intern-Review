json.extract! @account, :id, :name, :email, :avatar_url
json.account_type @account.accountable_type

unless @account.admin_user?
	json.batch @batch.name
end

if @account.intern?
	json.technology @user.technology
	json.courses do
		json.array! @course_reports do |course_report|
			course = course_report.course
			json.extract! course, :id, :title
			json.extract! course_report, :start_date, :end_date
			json.url api_course_url(course, format: :json)
		end
	end

	json.trainers do
		json.array! @trainers do |trainer|
			json.id trainer.id
			json.name trainer.name
			json.url api_account_url(trainer.account.id, format: :json)
		end
	end

	json.reviews do
		json.array! @course_reports.map(&:review), partial: "api/reviews/review", as: :review
	end

	json.section_reports do
		json.array! @section_reports do |section_report|
			json.partial! "api/sections/section", locals: { section: section_report.section }
			json.extract! section_report, :start_date, :end_date, :status

			json.daily_reports do
				json.array! section_report.daily_reports, partial: "api/daily_reports/daily_report", as: :daily_report
			end
		end
	end
end

if @account.trainer?
	json.interns do
		json.array! @interns do |intern|
			json.id intern.id
			json.name intern.name
			json.technology intern.technology
			json.url api_account_url(intern.account.id, format: :json)
		end
	end

	json.course do
		json.id @course.id
		json.title @course.title
		json.url api_course_url(@course, format: :json)
	end
end

if @account.admin_user?
	json.batches do
		json.array! @batches do |batch|
			json.extract! batch, :id, :name, :status

			json.trainers do
				json.array! batch.trainers do |trainer|
					json.id trainer.id
					json.name trainer.name
					json.url api_account_url(trainer.account.id, format: :json)
				end
			end

			json.interns do
				json.array! batch.interns do |intern|
					json.id intern.id
					json.name intern.name
					json.technology intern.technology
					json.url api_account_url(intern.account.id, format: :json)
				end
			end
		end
	end

	json.reviews do
		json.array! @reviews, partial: "api/reviews/review", as: :review
	end
end