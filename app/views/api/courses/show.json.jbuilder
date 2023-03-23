json.partial! "api/courses/course", course: @course
json.sections do
	json.array! @sections, partial: "api/sections/section", as: :section
end