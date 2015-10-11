require 'spec_helper'

describe ActiveRecordSurveyApi::QuestionsController, :type => :controller, :questions_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'When creating a new survey' do
		describe 'POST create' do
			it 'should work for english' do
				survey = ActiveRecordSurvey::Survey.create

				request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
				header_params = {
					:survey_id => survey.id,
					:HTTP_ACCEPT_LANGUAGE => 'en',
					:CONTENT_TYPE => 'application/json',
					:ACCEPT => 'application/json'
				}

				post :create,
				{
					:question => {
						:text => "How are you today?"
					}
				}.to_json, header_params

				post :create,
				{
					:question => {
						:text => "What is your favorite colour?"
					}
				}.to_json, header_params

				#survey.node_maps.each { |node_map|
				#	puts node_map.node.as_json
				#}
			end
		end
		describe 'GET index' do
			it 'should get only unique questions for the survey' do
				survey = ActiveRecordSurvey::Survey.new(:name => "My First Survey")
				
				# Question 1
				q1 = ActiveRecordSurvey::Node::Question.new(:text => "How are you doing today?")
				q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Great!")
				q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Good")
				q1_a3 = ActiveRecordSurvey::Node::Answer.new(:text => "Not Bad")
				q1_a4 = ActiveRecordSurvey::Node::Answer.new(:text => "Don't ask")
				nodes = survey.build_question(q1, [q1_a1,q1_a2,q1_a3,q1_a4])
				survey.save

				header_params = {
					:HTTP_ACCEPT_LANGUAGE => 'en',
					:CONTENT_TYPE => 'application/json',
					:ACCEPT => 'application/json'
				}

				request.headers[:HTTP_ACCEPT_LANGUAGE] = "es"
				get :index, {
					:survey_id => survey.id
				}, header_params

				puts response.body.as_json
			end
		end
=begin
		describe 'GET index' do
			it 'should work for english' do
				question = ActiveRecordSurveyApi::Question.new
				question.attributes = {
					text: "Comment allez-vous aujourd'hui?",
					locale: :fr
				}
				question.attributes = {
					text: "How are you today?",
					locale: :en
				}
				question.save

				request.headers['HTTP_ACCEPT_LANGUAGE'] = "en"
				get :index, nil, {
					'HTTP_ACCEPT_LANGUAGE' => 'en',
					'CONTENT_TYPE' => 'application/json',
					'ACCEPT' => 'application/json'
				}
				puts response.body.inspect
			end

			it 'should work for french' do
				question = ActiveRecordSurveyApi::Question.new
				question.attributes = {
					text: "¿Cuáles son tus planes?",
					locale: :es
				}
				question.attributes = {
					text: "What are your plans?",
					locale: :en
				}
				question.save

				request.headers['HTTP_ACCEPT_LANGUAGE'] = "es"
				get :index, nil, {
					'HTTP_ACCEPT_LANGUAGE' => 'es',
					'CONTENT_TYPE' => 'application/json',
					'ACCEPT' => 'application/json'
				}
				puts response.body.inspect
			end
		end
=end
=begin
			it 'should work for french' do
				request.headers['HTTP_ACCEPT_LANGUAGE'] = "fr"
				post :create, {
						:question => {
							:text => "Comment allez-vous aujourd'hui?"
						}
					}.to_json, {
					'HTTP_ACCEPT_LANGUAGE' => 'fr',
					'CONTENT_TYPE' => 'application/json',
					'ACCEPT' => 'application/json'
				}
				puts response.body.inspect
			end
=end
	end
end