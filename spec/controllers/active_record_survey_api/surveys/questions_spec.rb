require 'spec_helper'

describe ActiveRecordSurveyApi::QuestionsController, :type => :controller, :questions_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		I18n.locale = :en
		request.headers[:HTTP_ACCEPT_LANGUAGE] = :en
		@header_params = {
			:CONTENT_TYPE => 'application/json',
			:ACCEPT => 'application/json'
		}
	end

	describe 'next-question' do
		it 'should link/unlink and get the next question' do
			I18n.locale = :en

			survey = FactoryGirl.build(:basic_survey)
			survey.save

			map = survey.as_map

			# Get a final answer
			answer = map[0][:children][2][:children][0][:children][0]

			# Link new question to the final answer
			answer = ActiveRecordSurvey::Node::Answer.find(answer[:node_id])
			question_a = ActiveRecordSurvey::Node::Question.new(:text => "New Question #1", :survey => survey)
			answer.build_link(question_a)
			survey.save

			# Should be nothing initially
			get :get_next_question,
			{
				:question_id => question_a.id
			}, @header_params.merge(:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>[], "meta"=>{"total"=>0}})

			question_b = ActiveRecordSurvey::Node::Question.new(:text => "New Question #2", :survey => survey)
			question_b.save

			# Link New Question #1 -> New Question #2
			post :link_next_question,
			{
				:question_id => question_b.id
			}.to_json, @header_params.merge(:question_id => question_a.id, :HTTP_ACCEPT_LANGUAGE => 'en')

			# Get next-question for New Question #1
			get :get_next_question,
			{
				:question_id => question_a.id
			}, @header_params.merge(:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			# Response to now be New Question #2
			expect(json_body).to eq({"data"=>[{"id"=>"15", "type"=>"questions", "attributes"=>{"text"=>"New Question #2"}, "links"=>{"self"=>"/questions/15"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/15/relationships/next-question", "related"=>"/questions/15/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/15/relationships/answers", "related"=>"/questions/15/answers"}}}}], "meta"=>{"total"=>1}})

			delete :unlink_next_question,
			{
				:question_id => question_a.id
			}, @header_params.merge(:HTTP_ACCEPT_LANGUAGE => 'en')

			# Get next-question for New Question #1
			get :get_next_question,
			{
				:question_id => question_a.id
			}, @header_params.merge(:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>[], "meta"=>{"total"=>0}})
		end
	end

	describe 'GET index' do
		it 'should retrieve all questions for a survey' do
			I18n.locale = :en

			survey = FactoryGirl.build(:basic_survey)
			survey.save

			get :index,
			{
			}.to_json, @header_params.merge(:survey_id => survey.id,:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			expect(json_body["meta"]["total"]).to eq(4)
		end
	end

	describe 'translation' do
		context 'when english' do
			it 'should translate to french' do
				I18n.locale = :en

				survey = ActiveRecordSurvey::Survey.create(:name => "Survey")
				q1 = ActiveRecordSurvey::Node::Question.new(:text => "How are you today?")
				q1.save

				# Create two questions in english
				request.headers[:HTTP_ACCEPT_LANGUAGE] = :fr

				put :update,
				{
					:question => {
						:attributes => {
							:text => "Comment allez-vous aujourd'hui?"
						}
					}
				}.to_json, @header_params.merge(:id => q1.id)

				q1.reload

				expect(q1.translations.collect { |i|
					{ :text => i.text, :locale => i.locale }
				}.as_json).to eq([{"text"=>"How are you today?", "locale"=>"en"}, {"text"=>"Comment allez-vous aujourd'hui?", "locale"=>"fr"}])
			end

			it 'should should update the english' do
				I18n.locale = :en

				survey = ActiveRecordSurvey::Survey.create(:name => "Survey")
				q1 = ActiveRecordSurvey::Node::Question.new(:text => "How are you today?")
				q1.save

				# Create two questions in english
				request.headers[:HTTP_ACCEPT_LANGUAGE] = :en

				put :update,
				{
					:question => {
						:attributes => {
							:text => "How are you doing today?"
						}
					}
				}.to_json, @header_params.merge(:id => q1.id)

				q1.reload

				expect(q1.translations.collect { |i|
					{ :text => i.text, :locale => i.locale }
				}.as_json).to eq([{"text"=>"How are you doing today?", "locale"=>"en"}])
			end
		end
	end

	describe 'When creating new questions' do
		describe 'POST create' do
			it 'should work for english' do
				I18n.locale = :en
				survey = ActiveRecordSurvey::Survey.create

				request.headers[:HTTP_ACCEPT_LANGUAGE] = :en

				post :create,
				{
					:question => {
						:attributes => {
							:text => "How are you today?"
						}
					}
				}.to_json, @header_params.merge(:survey_id => survey.id)

				json_body = JSON.parse(response.body)

				expect(json_body).to eq({"data"=>{"id"=>"1", "type"=>"questions", "attributes"=>{"text"=>"How are you today?"}, "links"=>{"self"=>"/questions/1"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/1/relationships/next-question", "related"=>"/questions/1/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/1/relationships/answers", "related"=>"/questions/1/answers"}}}}})

				post :create,
				{
					:question => {
						:attributes => {
							:text => "What is your favorite colour?"
						}
					}
				}.to_json, @header_params.merge(:survey_id => survey.id)

				json_body = JSON.parse(response.body)

				expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"questions", "attributes"=>{"text"=>"What is your favorite colour?"}, "links"=>{"self"=>"/questions/2"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/2/relationships/next-question", "related"=>"/questions/2/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/2/relationships/answers", "related"=>"/questions/2/answers"}}}}})

				survey.reload
				expect(survey.questions.length).to eq(2)
			end
		end

		describe 'GET index' do
			it 'should get only unique questions for the survey in english and french' do
				I18n.locale = :fr

				survey = ActiveRecordSurvey::Survey.new(:name => "My First Survey")

				# Question 1
				q1 = ActiveRecordSurvey::Node::Question.new(:text => "How are you doing today?", :survey => survey)
				q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Great!")
				q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Good")
				q1_a3 = ActiveRecordSurvey::Node::Answer.new(:text => "Not Bad")
				q1_a4 = ActiveRecordSurvey::Node::Answer.new(:text => "Don't ask")
				q1.build_answer(q1_a1)
				q1.build_answer(q1_a2)
				q1.build_answer(q1_a3)
				q1.build_answer(q1_a4)

				q2 = ActiveRecordSurvey::Node::Question.new(:text => "What are you doing today?", :survey => survey)
				q2_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Working")
				q2_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Playing")
				q2_a3 = ActiveRecordSurvey::Node::Answer.new(:text => "Don't ask")
				q2.build_answer(q2_a1)
				q2.build_answer(q2_a2)
				q2.build_answer(q2_a3)

				q3 = ActiveRecordSurvey::Node::Question.new(:text => "Select your favorite foods", :survey => survey)
				q3_a1 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Pizza")
				q3_a2 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Hamburgers")
				q3_a3 = ActiveRecordSurvey::Node::Answer::Boolean.new(:text => "Salad")
				q3.build_answer(q3_a1)
				q3.build_answer(q3_a2)
				q3.build_answer(q3_a3)

				q1_a3.build_link(q2)
				q1_a2.build_link(q3)
				q2_a2.build_link(q3)

				survey.save

				request.headers[:HTTP_ACCEPT_LANGUAGE] = :en
				get :index, {
					:survey_id => survey.id
				}, @header_params

				# English request should yield no text!
				json_body = JSON.parse(response.body)
				expect(json_body).to eq({"data"=>[{"id"=>"1", "type"=>"questions", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/questions/1"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/1/relationships/next-question", "related"=>"/questions/1/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/1/relationships/answers", "related"=>"/questions/1/answers"}}}}, {"id"=>"4", "type"=>"questions", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/questions/4"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/4/relationships/next-question", "related"=>"/questions/4/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/4/relationships/answers", "related"=>"/questions/4/answers"}}}}, {"id"=>"9", "type"=>"questions", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/questions/9"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/9/relationships/next-question", "related"=>"/questions/9/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/9/relationships/answers", "related"=>"/questions/9/answers"}}}}], "meta"=>{"total"=>3}})

				request.headers[:HTTP_ACCEPT_LANGUAGE] = :fr
				get :index, {
					:survey_id => survey.id
				}, @header_params

				# French request should yield the french text!
				json_body = JSON.parse(response.body)
				expect(json_body).to eq({"data"=>[{"id"=>"1", "type"=>"questions", "attributes"=>{"text"=>"How are you doing today?"}, "links"=>{"self"=>"/questions/1"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/1/relationships/next-question", "related"=>"/questions/1/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/1/relationships/answers", "related"=>"/questions/1/answers"}}}}, {"id"=>"4", "type"=>"questions", "attributes"=>{"text"=>"Select your favorite foods"}, "links"=>{"self"=>"/questions/4"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/4/relationships/next-question", "related"=>"/questions/4/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/4/relationships/answers", "related"=>"/questions/4/answers"}}}}, {"id"=>"9", "type"=>"questions", "attributes"=>{"text"=>"What are you doing today?"}, "links"=>{"self"=>"/questions/9"}, "relationships"=>{"next-question"=>{"links"=>{"self"=>"/questions/9/relationships/next-question", "related"=>"/questions/9/next-question"}}, "answers"=>{"links"=>{"self"=>"/questions/9/relationships/answers", "related"=>"/questions/9/answers"}}}}], "meta"=>{"total"=>3}})
			end
		end
	end
end