json.extract! section, :id, :title, :context
json.extract! section, :days_required, :course_id
json.url api_section_url(section, format: :json)