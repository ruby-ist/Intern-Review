json.extract! daily_report, :id, :date, :status, :progress, :feedback

if current_account.admin_user?
	json.batch daily_report.section_report.intern.batch.name
end

json.section_id daily_report.section_report.section_id
json.intern_id daily_report.section_report.intern_id