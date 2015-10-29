require 'spec_helper'

describe ActiveRecordSurveyApi::QuestionsController, :type => :controller, :questions_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
		@header_params = {
			:CONTENT_TYPE => 'application/json',
			:ACCEPT => 'application/json'
		}
	end

	describe 'translation', :focus => true do
		context 'when english' do
			it 'should translate to french' do
				survey = ActiveRecordSurvey::Survey.create(:name => "Survey")
				q1 = ActiveRecordSurvey::Node::Question.new(:text => "How are you today?")
				q1.save
	
				# Create two questions in english
				request.headers[:HTTP_ACCEPT_LANGUAGE] = :fr

				put :update,
				{
					:question => {
						:text => "Comment allez-vous aujourd'hui?"
					}
				}.to_json, @header_params.merge(:id => q1.id)

				q1.reload

				expect(q1.translations.collect { |i|
					{ :text => i.text, :locale => i.locale }
				}.as_json).to eq([{"text"=>"How are you today?", "locale"=>"en"}, {"text"=>"Comment allez-vous aujourd'hui?", "locale"=>"fr"}])
			end

			it 'should should update the english' do
				I18n.locale = :en

				survey = ActiveRecordSurvey::Survey.create(:name => "Survey")
				q1 = ActiveRecordSurvey::Node::Question.new(:text => "How are you today?")
				q1.save

				# Create two questions in english
				request.headers[:HTTP_ACCEPT_LANGUAGE] = :en

				put :update,
				{
					:question => {
						:text => "How are you doing today?"
					}
				}.to_json, @header_params.merge(:id => q1.id)

				q1.reload

				expect(q1.translations.collect { |i|
					{ :text => i.text, :locale => i.locale }
				}.as_json).to eq([{"text"=>"How are you doing today?", "locale"=>"en"}])
			end
		end
	end

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
				survey.build_question(q1)
				q1.build_answer(q1_a1, survey)
				q1.build_answer(q1_a2, survey)
				q1.build_answer(q1_a3, survey)
				q1.build_answer(q1_a4, survey)

				q2 = ActiveRecordSurvey::Node::Question.new(:text => "What are you doing today?")
				q2_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Working")
				q2_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Playing")
				q2_a3 = ActiveRecordSurvey::Node::Answer.new(:text => "Don't ask")
				survey.build_question(q2)
				q2.build_answer(q2_a1, survey)
				q2.build_answer(q2_a2, survey)
				q2.build_answer(q2_a3, survey)

				q3 = ActiveRecordSurvey::Node::Question.new(:text => "Select your favorite foods")
				q3_a1 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Pizza")
				q3_a2 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Hamburgers")
				q3_a3 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Salad")
				survey.build_question(q3)
				q3.build_answer(q3_a1, survey)
				q3.build_answer(q3_a2, survey)
				q3.build_answer(q3_a3, survey)

				q1_a3.build_link(q2)
				q1_a2.build_link(q3)
				q2_a2.build_link(q3)

				survey.save

				header_params = {
					:HTTP_ACCEPT_LANGUAGE => 'en',
					:CONTENT_TYPE => 'application/json',
					:ACCEPT => 'application/json'
				}

				request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
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