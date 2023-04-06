json.daily_reports do
	json.array! @daily_reports, partial: "api/daily_reports/daily_report", as: :daily_report
end

unless @daily_reports.first_page?
	options = {page: @daily_reports.prev_page}
	options[:date] = params[:date] if params[:date].present?
	json.prev_reports_url api_daily_reports_url(**options)
end

unless @daily_reports.last_page?
	options = {page: @daily_reports.next_page}
	options[:date] = params[:date] if params[:date].present?
	json.next_reports_url api_daily_reports_url(**options)
end