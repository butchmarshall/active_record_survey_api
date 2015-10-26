ActiveRecordSurveyApi::Engine.routes.draw do
	resources :instances
	resources :surveys do
		resources :instances do
			resources :instance_nodes
		end
		resources :questions do
			resources :answers
		end
	end
	resources :questions do
		resources :answers
	end
end