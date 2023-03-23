json.extract! course, :id, :title, :image_url, :description, :duration, :account_id
json.url api_course_url(course, format: :json)