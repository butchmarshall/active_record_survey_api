require 'spec_helper'
=begin
describe ActiveRecordSurvey::SurveysController, :type => :controller do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'GET index' do

		it 'has a version number' do
			ActiveRecordSurvey::Survey.create
			ActiveRecordSurvey::Survey.create
			ActiveRecordSurvey::Survey.create
			ActiveRecordSurvey::Survey.create
			ActiveRecordSurvey::Survey.create
			
			get :index
			
			puts response.body.inspect
		end
	end
end
=end