require 'spec_helper'

describe ActiveRecordSurveyApi::AnswersController, :type => :controller, :answers_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'When creating a new survey' do
		describe 'POST create' do
			it 'should work for english' do
				survey = ActiveRecordSurvey::Survey.create

				# Question 1
				question1 = ActiveRecordSurvey::Node::Question.create(
					:text => "How are you doing today?"
				)
				survey.build_question(question1, [])

				# Question 2
				question2 = ActiveRecordSurvey::Node::Question.create(
					:text => "What food do you like?"
				)
				survey.build_question(question2, [])

				survey.save

				# Default answer type
				# Add Question 1 Answers
				request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
				header_params = {
					:survey_id => survey.id,
					:question_id => question1.id,
					:HTTP_ACCEPT_LANGUAGE => 'en',
					:CONTENT_TYPE => 'application/json',
					:ACCEPT => 'application/json'
				}

				post :create,
				{
					:answer => {
						:text => "Great!"
					}
				}.to_json, header_params

				post :create,
				{
					:answer => {
						:text => "Oh, you know, I'm OK."
					}
				}.to_json, header_params

				post :create,
				{
					:answer => {
						:text => "It's definitely a Monday."
					}
				}.to_json, header_params

				# Boolean answer type
				# Add Question 2 Answers
				request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
				header_params = {
					:survey_id => survey.id,
					:question_id => question2.id,
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

				# Should fail
				post :create,
				{
					:type => "boolean",
					:answer => {
						:text => "Spagetti"
					}
				}.to_json, header_params

				# Should fail
				post :create,
				{
					:answer => {
						:text => "Nachos"
					}
				}.to_json, header_params

#puts response.body.inspect

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