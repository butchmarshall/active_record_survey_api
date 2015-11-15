Rails.application.routes.draw do
	root 'application#angular'

	mount ActiveRecordSurveyApi::Engine => "/"
end