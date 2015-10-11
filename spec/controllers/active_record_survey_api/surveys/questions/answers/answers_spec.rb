require 'spec_helper'

describe ActiveRecordSurveyApi::AnswersController, :type => :controller, :answer_answers_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'When creating a new survey' do
		describe 'POST create' do
			it 'should work for english' do
				survey = ActiveRecordSurvey::Survey.create

				question = ActiveRecordSurvey::Node::Question.create(
					:text => "What food do you like?"
				)
				survey.build_question(question, [])

				survey.save

				# Default answer type
				# Add Question 1 Answers
				request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
				header_params = {
					:survey_id => survey.id,
					:question_id => question.id,
					:HTTP_ACCEPT_LANGUAGE => 'en',
					:CONTENT_TYPE => 'application/json',
					:ACCEPT => 'application/json'
				}

				post :create,
				{
					:answer => {
						:text => "Pizza"
					}
				}.to_json, header_params

				json_response = JSON.parse(response.body)

				header_params[:answer_id] = json_response["data"]["id"]
				# Should fail
				post :create,
				{
					:type => "boolean",
					:answer => {
						:text => "Spagetti"
					}
				}.to_json, header_params

				json_response = JSON.parse(response.body)

				header_params[:answer_id] = json_response["data"]["id"]
				# Should fail
				post :create,
				{
					:answer => {
						:text => "Nachos"
					}
				}.to_json, header_params

				puts "--------------------------------------------------"
				puts survey.as_map.as_json.inspect
				puts "--------------------------------------------------"
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
end