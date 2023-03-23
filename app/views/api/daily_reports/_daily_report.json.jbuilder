json.extract! daily_report, :id, :date, :status
json.progress simple_format(h(daily_report.progress))
json.feedback simple_format(h(daily_report.feedback))

if current_account.admin_user?
	json.batch daily_report.section_report.intern.batch.name
end

json.section_id daily_report.section_report.section_id
json.intern_id daily_report.section_report.intern_id