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
			json.id course.id
			json.name course.title
			json.url course_url(course, format: :json)
		end
	end

	json.trainers do
		json.array! @trainers do |trainer|
			json.id trainer.id
			json.name trainer.name
			json.url account_url(trainer.account.id, format: :json)
		end
	end

	json.section_reports do
		json.array! @section_reports do |section_report|
			json.partial! "sections/section", locals: { section: section_report.section }
			json.start_date section_report.start_date
			json.end_date section_report.end_date
			json.status section_report.status

			json.daily_reports do
				json.array! section_report.daily_reports, partial: "daily_reports/daily_report", as: :daily_report
			end
		end
	end
end

if @account.trainer?
	json.interns do
		json.array! @interns do |intern|
			json.id intern.id
			json.name intern.name
			json.url account_url(intern.account.id, format: :json)
		end
	end

	json.course do
		json.id @course.id
		json.title @course.title
		json.url course_url(@course, format: :json)
	end
end

if @account.admin_user?
	json.batches do
		json.array! @batches do |batch|
			json.id batch.id
			json.name batch.name

			json.trainers do
				json.array! batch.trainers do |trainer|
					json.id trainer.id
					json.name trainer.name
					json.url account_url(trainer.account.id, format: :json)
				end
			end

			json.interns do
				json.array! batch.interns do |intern|
					json.id intern.id
					json.name intern.name
					json.url account_url(intern.account.id, format: :json)
				end
			end
		end
	end

	json.reviews do
		json.array! @reviews do |review|
			json.id review.id
			json.feedback review.feedback

			json.intern_id review.course_report.intern.id
			json.course_id review.course_report.course.id
		end
	end
end