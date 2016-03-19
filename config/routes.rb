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
	resources :answers do
		get 'next-question', to: 'answers#get_next_question'
		get 'relationships/next-question', to: 'answers#get_next_question'
		post 'relationships/next-question', to: 'answers#link_next_question', as: "link_next_question"
		delete 'relationships/next-question', to: 'answers#unlink_next_question', as: "unlink_next_question"
	end
end