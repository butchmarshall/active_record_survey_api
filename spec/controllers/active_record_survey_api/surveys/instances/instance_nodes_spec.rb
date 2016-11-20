require 'spec_helper'

describe ActiveRecordSurveyApi::InstanceNodesController, :type => :controller, :instance_nodes_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	describe 'POST create' do
		it 'should create a new instance' do
			survey = FactoryGirl.build(:basic_survey)
			survey.save

			instance = ActiveRecordSurvey::Instance.new(:survey => survey)
			instance.save

			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
			header_params = {
				:survey_id => survey.id,
				:instance_id => instance.id,
				:HTTP_ACCEPT_LANGUAGE => 'en',
				:CONTENT_TYPE => 'application/json',
				:ACCEPT => 'application/json'
			}

			questions = survey.questions

			survey_path = survey.as_map.as_json.first

			post :create,
			{
				:instance_node => {
					:active_record_survey_node_id => survey_path["children"].first["node_id"]
				}
			}.to_json, header_params

			json_body = JSON.parse(response.body)

			expect(json_body["data"]["id"].to_i).to eq(1)
		end
	end
end