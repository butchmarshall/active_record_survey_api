ActiveRecordSurveyApi::Engine.routes.draw do
	resources :instances
	resources :surveys do
		resources :instances do
			resources :instance_nodes
		end
		resources :questions do
			resources :answers
		end
		resources :node_map_groups, as: "pages"
	end
	resources :node_map_groups, as: "pages"
	resources :questions do
		resources :answers

		get 'relationships/next-question', to: 'questions#get_next_question' # Array of all possible next questions from this question
		post 'relationships/next-question', to: 'questions#link_next_question', as: "link_next_question" # Sets the next question for itself, or for *all answers* of the question
		delete 'relationships/next-question', to: 'questions#unlink_next_question', as: "unlink_next_question"
	end
	resources :answers do
		get 'next-question', to: 'answers#get_next_question'
		get 'relationships/next-question', to: 'answers#get_next_question'
		post 'relationships/next-question', to: 'answers#link_next_question', as: "link_next_answer_question"
		delete 'relationships/next-question', to: 'answers#unlink_next_question', as: "unlink_next_answer_question"
	end
end