require 'spec_helper'

describe ActiveRecordSurveyApi::SurveysController, :type => :controller, :surveys_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
		@header_params = {
			:HTTP_ACCEPT_LANGUAGE => 'en',
			:CONTENT_TYPE => 'application/json',
			:ACCEPT => 'application/json'
		}
	end

	describe 'POST create' do
		it 'should create a new survey' do
			post :create,
			{
				:survey => {
					:attributes => {
						:name => "API Created Survey"
					}
				}
			}.to_json, @header_params.merge(:HTTP_ACCEPT_LANGUAGE => 'en')

			json_body = JSON.parse(response.body)

			expect(json_body["data"]["attributes"]["name"]).to eq("API Created Survey")
		end
	end

	describe 'GET index' do
		it 'should list existing surveys' do
			ActiveRecordSurvey::Survey.create(:name => "Survey #1")
			ActiveRecordSurvey::Survey.create(:name => "Survey #2")
			ActiveRecordSurvey::Survey.create(:name => "Survey #3")
			ActiveRecordSurvey::Survey.create(:name => "Survey #4")
			ActiveRecordSurvey::Survey.create(:name => "Survey #5")

			get :index

			json_body = JSON.parse(response.body)

			expect(json_body["meta"]["total"]).to eq(5)
		end
	end
end