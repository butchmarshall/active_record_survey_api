require 'spec_helper'
=begin
describe ActiveRecordSurveyApi::AnswersController, :type => :controller, :answers_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'When creating a new survey' do
		describe 'GET index' do
			it 'should work for english' do
				answer = ActiveRecordSurveyApi::Answer.new
				answer.attributes = {
					text: "Comment allez-vous aujourd'hui?",
					locale: :fr
				}
				answer.attributes = {
					text: "How are you today?",
					locale: :en
				}
				answer.save

				request.headers['HTTP_ACCEPT_LANGUAGE'] = "en"
				get :index, nil, {
					'HTTP_ACCEPT_LANGUAGE' => 'en',
					'CONTENT_TYPE' => 'application/json',
					'ACCEPT' => 'application/json'
				}
				puts response.body.inspect
			end

			it 'should work for french' do
				answer = ActiveRecordSurveyApi::Answer.new
				answer.attributes = {
					text: "¿Cuáles son tus planes?",
					locale: :es
				}
				answer.attributes = {
					text: "What are your plans?",
					locale: :en
				}
				answer.save

				request.headers['HTTP_ACCEPT_LANGUAGE'] = "es"
				get :index, nil, {
					'HTTP_ACCEPT_LANGUAGE' => 'es',
					'CONTENT_TYPE' => 'application/json',
					'ACCEPT' => 'application/json'
				}
				puts response.body.inspect
			end
		end

		it 'should create' do
			#post :create, {
			#	:survey => {
			#		:name => "Survey #1",
			#	}
			#}.to_json, {
			#	'CONTENT_TYPE' => 'application/json',
			#	'ACCEPT' => 'application/json'
			#}

			#puts response.body.inspect
		end
	end
end
=end