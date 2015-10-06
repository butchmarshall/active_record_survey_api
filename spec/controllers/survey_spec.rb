require 'spec_helper'
=begin
describe SurveysController, :type => :controller do
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