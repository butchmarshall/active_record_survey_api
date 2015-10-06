ActiveRecordSurveyApi::Engine.routes.draw do
	resources :surveys do
		resources :questions do
			resources :answers
		end
	end
	resources :questions do
		resources :answers
	end
	resources :answers do
		resources :answers
	end
end