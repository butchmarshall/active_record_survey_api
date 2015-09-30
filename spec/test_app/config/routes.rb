Rails.application.routes.draw do
	mount ActiveRecordSurveyApi::Engine => "/surveys"
end