require 'spec_helper'

describe ActiveRecordSurveyApi::SurveysController, :type => :controller do
	routes { ActiveRecordSurveyApi::Engine.routes }
	it 'has a version number' do
		get :index
	end
end