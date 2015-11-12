require 'spec_helper'

describe ActiveRecordSurveyApi::AnswersController, :type => :controller, :answers_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		I18n.locale = :en
	end

	describe 'When creating a new survey' do
		describe 'POST create' do
			it 'should work for english' do
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
					:type => "boolean",
					:answer => {
						:text => "Nachos"
					}
				}.to_json, header_params

puts response.body.inspect

				puts "--------------------------------------------------"
				puts JSON.pretty_generate(survey.as_map.as_json)
				puts "--------------------------------------------------"
			end
		end
	end
end