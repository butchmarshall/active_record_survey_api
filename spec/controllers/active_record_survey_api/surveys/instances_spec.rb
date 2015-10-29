require 'spec_helper'

describe ActiveRecordSurveyApi::InstancesController, :type => :controller, :instances_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

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
		it 'should bulk update instance responses', :focus_broken => true do
			survey = FactoryGirl.build(:basic_survey)
			survey.save

			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"
			header_params = {
				:survey_id => survey.id,
				:HTTP_ACCEPT_LANGUAGE => 'en',
				:CONTENT_TYPE => 'application/json',
				:ACCEPT => 'application/json'
			}

			#puts JSON.pretty_generate(survey.as_map)

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
						{ :active_record_survey_node_id => 317 },
						{ :active_record_survey_node_id => 319 },
						{ :active_record_survey_node_id => 323 },
					]
				}
			}.to_json, header_params

			put :update,
			{
				:instance => {
					:instance_nodes_attributes => [
						{ :active_record_survey_node_id => 321 },
						{ :active_record_survey_node_id => 323 },
					]
				}
			}.to_json, header_params

			put :update,
			{
				:instance => {
					:instance_nodes_attributes => [
						{ :active_record_survey_node_id => 321 },
						{ :active_record_survey_node_id => 323 },
						{ :active_record_survey_node_id => 322 },
					]
				}
			}.to_json, header_params

			#puts response.body.inspect
		end
	end
end