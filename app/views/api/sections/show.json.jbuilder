json.partial! "api/sections/section", section: @section
if current_account.intern?
	json.extract! @section_report, :start_date, :end_date, :status
end

json.references do
	json.array! @section.references, partial: "api/references/reference", as: :reference
end

json.daily_reports do
	json.array! @daily_reports, partial: "api/daily_reports/daily_report", as: :daily_report
end