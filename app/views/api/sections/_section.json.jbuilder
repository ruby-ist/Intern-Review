json.extract! section, :id, :title
json.context simple_format(h(section.context))
json.extract! section, :days_required, :course_id
json.url api_section_url(section, format: :json)