Rails.application.routes.draw do
	mount ActiveRecordSurveyApi::Engine => "/surveys"

	resources :surveys do
		resources :questions do
		end
	end
end