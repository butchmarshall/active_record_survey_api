require 'spec_helper'

describe ActiveRecordSurveyApi::AnswersController, :type => :controller, :answers_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		I18n.locale = :en

		@header_params = {
			:HTTP_ACCEPT_LANGUAGE => 'en',
			:CONTENT_TYPE => 'application/json',
			:ACCEPT => 'application/json'
		}
	end

	describe 'GET index' do
		it 'should retrieve all answers for a question' do
			I18n.locale = :en

			survey = FactoryGirl.build(:basic_survey)
			survey.save

			expected_total_answers_at_index = [
				3,2,2,2
			]
			survey.questions.each_with_index { |question, index|
				get :index,
				{
				}.to_json, @header_params.merge(:question_id => question.id,:HTTP_ACCEPT_LANGUAGE => 'en')
				json_body = JSON.parse(response.body)

				expect(json_body["meta"]["total"]).to eq(expected_total_answers_at_index[index])
			}
		end
	end
	describe 'PUT update' do
		it 'should update answers in english and french' do
			survey = FactoryGirl.build(:basic_survey)
			survey.save

			# ------------------------------------------------------------------------------
			# Answers should be updateable in each language
			# ------------------------------------------------------------------------------

			I18n.locale = :en

			put :update,
			{
				:answer => {
					:attributes => {
						:text => "It's definitely a Monday."
					}
				}
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)
			
			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"It's definitely a Monday."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}}}})

			I18n.locale = :fr

			put :update,
			{
				:answer => {
					:attributes => {
						:text => "Il est certainement un lundi."
					}
				}
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'fr')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"Il est certainement un lundi."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}}}})

			# ------------------------------------------------------------------------------
			# Answers should be retrievable in each translated language
			# ------------------------------------------------------------------------------

			I18n.locale = :en

			get :show,
			{
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)
			
			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"It's definitely a Monday."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}}}})

			I18n.locale = :fr

			get :show,
			{
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'fr')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"Il est certainement un lundi."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}}}})
			

			# ------------------------------------------------------------------------------
			# All answers should be retrievable in language for each question
			# ------------------------------------------------------------------------------

			I18n.locale = :en

			get :index,
			{
			}.to_json, @header_params.merge(:question_id => 1,:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>[{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"It's definitely a Monday."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}}}, {"id"=>"11", "type"=>"answer_answers", "attributes"=>{"text"=>"Q1 Answer #2"}, "links"=>{"self"=>"/answers/11"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/11/relationships/question", "related"=>"/answers/11/question"}}}}, {"id"=>"6", "type"=>"answer_answers", "attributes"=>{"text"=>"Q1 Answer #3"}, "links"=>{"self"=>"/answers/6"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/6/relationships/question", "related"=>"/answers/6/question"}}}}], "meta"=>{"total"=>3}})
			expect(json_body["meta"]["total"]).to eq(3)


			I18n.locale = :fr

			get :index,
			{
			}.to_json, @header_params.merge(:question_id => 1,:HTTP_ACCEPT_LANGUAGE => 'fr')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>[{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"Il est certainement un lundi."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}}}, {"id"=>"11", "type"=>"answer_answers", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/answers/11"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/11/relationships/question", "related"=>"/answers/11/question"}}}}, {"id"=>"6", "type"=>"answer_answers", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/answers/6"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/6/relationships/question", "related"=>"/answers/6/question"}}}}], "meta"=>{"total"=>3}})
			expect(json_body["meta"]["total"]).to eq(3)

			I18n.locale = :en

			get :index,
			{
			}.to_json, @header_params.merge(:question_id => 5,:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			expect(json_body["meta"]["total"]).to eq(2)
		end
	end
	describe 'POST create' do
		it 'should create new answers english', :workonme => true do
			survey = ActiveRecordSurvey::Survey.create

			# Question 1
			question1 = ActiveRecordSurvey::Node::Question.create(
				:text => "How are you doing today?"
			)
			survey.build_question(question1)

			# Question 2
			question2 = ActiveRecordSurvey::Node::Question.create(
				:text => "What food do you like?"
			)
			survey.build_question(question2)

			survey.save

			# Default answer type
			# Add Question 1 Answers
			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"

			post :create,
			{
				:answer => {
					:attributes => {
						:text => "Great!"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question1.id)

			post :create,
			{
				:answer => {
					:attributes => {
						:text => "Oh, you know, I'm OK."
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question1.id)

			post :create,
			{
				:answer => {
					:attributes => {
						:text => "It's definitely a Monday."
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question1.id)

			# Boolean answer type
			# Add Question 2 Answers
			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"

			post :create,
			{
				:answer => {
					:attributes => {
						:type => "boolean",
						:text => "Pizza"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question2.id)
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"6", "type"=>"boolean_answers", "attributes"=>{"text"=>"Pizza"}, "links"=>{"self"=>"/answers/6"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/6/relationships/question", "related"=>"/answers/6/question"}}}}})

			post :create,
			{
				:answer => {
					:attributes => {
						:type => "boolean",
						:text => "Spagetti"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question2.id)
			json_body = JSON.parse(response.body)
			expect(json_body).to eq({"data"=>{"id"=>"7", "type"=>"boolean_answers", "attributes"=>{"text"=>"Spagetti"}, "links"=>{"self"=>"/answers/7"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/7/relationships/question", "related"=>"/answers/7/question"}}}}})

			post :create,
			{
				:answer => {
					:attributes => {
						:type => "boolean",
						:text => "Nachos"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question2.id)
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"8", "type"=>"boolean_answers", "attributes"=>{"text"=>"Nachos"}, "links"=>{"self"=>"/answers/8"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/8/relationships/question", "related"=>"/answers/8/question"}}}}})

			# As Map should 
			expect(survey.as_map.as_json).to eq([                                                                                                                                                                                                                                                
				{                                                                                                                                                                                                                                                   
				  "text" => "How are you doing today?",                                                                                                                                                                                                               
				  "id" => 1,                                                                                                                                                                                                                                          
				  "node_id" => 1,                                                                                                                                                                                                                                     
				  "type" => "ActiveRecordSurvey::Node::Question",                                                                                                                                                                                                     
				  "children" => [                                                                                                                                                                                                                                     
					{                                                                                                                                                                                                                                               
					  "text" => "Great!",                                                                                                                                                                                                                             
					  "id" => 3,
					  "node_id" => 3,
					  "type" => "ActiveRecordSurvey::Node::Answer",
					  "children" => [
			  
					  ]
					},
					{
					  "text" => "Oh, you know, I'm OK.",
					  "id" => 4,
					  "node_id" => 4,
					  "type" => "ActiveRecordSurvey::Node::Answer",
					  "children" => [
			  
					  ]
					},
					{
					  "text" => "It's definitely a Monday.",
					  "id" => 5,
					  "node_id" => 5,
					  "type" => "ActiveRecordSurvey::Node::Answer",
					  "children" => [
			  
					  ]
					}
				  ]
				},
				{
				  "text" => "What food do you like?",
				  "id" => 2,
				  "node_id" => 2,
				  "type" => "ActiveRecordSurvey::Node::Question",
				  "children" => [
					{
					  "text" => "Pizza",
					  "id" => 6,
					  "node_id" => 6,
					  "type" => "ActiveRecordSurvey::Node::Answer::Boolean",
					  "children" => [
						{
						  "text" => "Spagetti",
						  "id" => 7,
						  "node_id" => 7,
						  "type" => "ActiveRecordSurvey::Node::Answer::Boolean",
						  "children" => [
							{
							  "text" => "Nachos",
							  "id" => 8,
							  "node_id" => 8,
							  "type" => "ActiveRecordSurvey::Node::Answer::Boolean",
							  "children" => [
			  
							  ]
							}
						  ]
						}
					  ]
					}
				  ]
				}
			])
		end
	end
end