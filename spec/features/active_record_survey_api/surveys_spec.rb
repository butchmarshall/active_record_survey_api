require 'spec_helper'
=begin
describe ActiveRecordSurvey::SurveysController, :type => :controller, :surveys_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'When creating a new survey' do

		it 'should create' do
			post :create, {
				:survey => {
					:name => "Survey #1",
				}
			}.to_json, {
				'CONTENT_TYPE' => 'application/json',
				'ACCEPT' => 'application/json'
			}

			puts response.body.inspect
		end
	end
end
=end