json.extract! review, :id, :admin_user_id
json.extract! review.course_report, :intern_id, :course_id
json.review review.feedback
json.extract! review, :progress, :status