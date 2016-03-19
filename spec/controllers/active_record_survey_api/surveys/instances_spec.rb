require 'spec_helper'

describe ActiveRecordSurveyApi::InstancesController, :type => :controller, :instances_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		I18n.locale = :en
	end

	describe 'CREATE' do
		it 'should create a new instance' do
			survey = FactoryGirl.build(:basic_survey)
			survey.save

			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
			header_params = {
				:survey_id => survey.id,
				:HTTP_ACCEPT_LANGUAGE => 'en',
				:CONTENT_TYPE => 'application/json',
				:ACCEPT => 'application/json'
			}

			post :create,
			{
			}.to_json, header_params
		end
	end

	describe 'PUT update/:id' do
		it 'should bulk update instance responses' do
			survey = FactoryGirl.build(:basic_survey)
			survey.save

			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
			header_params = {
				:survey_id => survey.id,
				:HTTP_ACCEPT_LANGUAGE => 'en',
				:CONTENT_TYPE => 'application/json',
				:ACCEPT => 'application/json'
			}

			# Create the instance
			post :create,
			{
			}.to_json, header_params

			json_body = JSON.parse(response.body)

			header_params[:id] = json_body["data"]["id"].to_i

			put :update,
			{
				:instance => {
					:instance_nodes_attributes => [
						{ :active_record_survey_node_id => 2 },
						{ :active_record_survey_node_id => 4 },
						{ :active_record_survey_node_id => 7 },
					]
				}
			}.to_json, header_params
			json_body = JSON.parse(response.body)

			put :update,
			{
				:instance => {
					:instance_nodes_attributes => [
						{ :active_record_survey_node_id => 5 },
						{ :active_record_survey_node_id => 7 },
					]
				}
			}.to_json, header_params
			json_body = JSON.parse(response.body)

			put :update,
			{
				:instance => {
					:instance_nodes_attributes => [
						{ :active_record_survey_node_id => 11 },
						{ :active_record_survey_node_id => 12 },
						{ :active_record_survey_node_id => 8 },
					]
				}
			}.to_json, header_params
			json_body = JSON.parse(response.body)

		end
	end
end
