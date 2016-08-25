require 'spec_helper'

describe ActiveRecordSurveyApi::NodeMapGroupsController, :type => :controller, :node_map_groups_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		I18n.locale = :en
		request.headers[:HTTP_ACCEPT_LANGUAGE] = :en
		@header_params = {
			:CONTENT_TYPE => 'application/json',
			:ACCEPT => 'application/json'
		}
		@survey = FactoryGirl.build(:pageable_survey)
		@survey.save

		@q1 = @survey.questions.select { |i| i.text == "Question #1" }.first
		@q1_a1 = @q1.answers.select { |i| i.text == "Q1 Answer #1" }.first
		@q1_a2 = @q1.answers.select { |i| i.text == "Q1 Answer #2" }.first

		@q2 = @survey.questions.select { |i| i.text == "Question #2" }.first
		@q2_a2 = @q2.answers.select { |i| i.text == "Q2 Answer #2" }.first

		@q3 = @survey.questions.select { |i| i.text == "Question #3" }.first
		@q3_a1 = @q3.answers.select { |i| i.text == "Q3 Answer #1" }.first
		@q3_a2 = @q3.answers.select { |i| i.text == "Q3 Answer #2" }.first

		@q4 = @survey.questions.select { |i| i.text == "Question #4" }.first
		@q5 = @survey.questions.select { |i| i.text == "Question #5" }.first
	end

	describe "CREATE" do
		describe "success" do
			it 'should succeed for single questions' do
				post :create,
				{
					:node_map_group => {
						:questions => [
							@q1.id,
						]
					}
				}.to_json, @header_params.merge(:survey_id => @survey.id)

				expect(response.status).to eq(200)
			end

			it 'should succeed for multiple questions' do
				post :create,
				{
					:node_map_group => {
						:questions => [
							@q3.id,
							@q4.id,
						]
					}
				}.to_json, @header_params.merge(:survey_id => @survey.id)

				expect(response.status).to eq(200)
			end
		end
		describe "failure" do
			it 'should fail when one of the questions branches' do
				post :create,
				{
					:node_map_group => {
						:questions => [
							@q1.id,
							@q2.id,
						]
					}
				}.to_json, @header_params.merge(:survey_id => @survey.id)

				expect(response.status).to eq(409)
			end
		end
	end
end