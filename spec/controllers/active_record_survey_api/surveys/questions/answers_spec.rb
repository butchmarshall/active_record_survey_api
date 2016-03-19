require 'spec_helper'

describe ActiveRecordSurveyApi::AnswersController, :type => :controller, :answers_api => true do
	routes { ActiveRecordSurveyApi::Engine.routes }

	before(:each) do
		I18n.locale = :en

		@header_params = {
			:HTTP_ACCEPT_LANGUAGE => 'en',
			:CONTENT_TYPE => 'application/json',
			:ACCEPT => 'application/json'
		}
	end

	describe 'POST to relationships/next-question' do
		it 'should link the answer and next question' do
			survey = FactoryGirl.build(:basic_survey)

			q = ActiveRecordSurvey::Node::Question.new(:text => "Question Linkable", :survey => survey)
			q_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Question Linkable Answer #1")
			q_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Question Linkable Answer #2")
			q.build_answer(q_a1)
			q.build_answer(q_a2)
			survey.save

			survey.reload
			expect(survey.as_map(:no_ids => true)).to eq([{"text"=>"Question #1", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q1 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #2", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q2 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q2 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}]}, {"text"=>"Q1 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #3", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}, {"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}])

			# Link
			post 'link_next_question', {
				question_id: 14
			}.to_json, @header_params.merge(:answer_id => 8,:HTTP_ACCEPT_LANGUAGE => 'en')

			survey.reload
			expect(survey.as_map(:no_ids => true)).to eq([{"text"=>"Question #1", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q1 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #2", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q2 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q2 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #3", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}, {"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}])

			# Unlink
			delete 'unlink_next_question', {
			}.to_json, @header_params.merge(:answer_id => 8,:HTTP_ACCEPT_LANGUAGE => 'en')

			survey.reload
			expect(survey.as_map(:no_ids => true)).to eq([{"text"=>"Question #1", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q1 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #2", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q2 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q2 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q1 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #3", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}, {"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}, {"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}])

			# Link
			post 'link_next_question', {
				question_id: 14
			}.to_json, @header_params.merge(:answer_id => 8,:HTTP_ACCEPT_LANGUAGE => 'en')

			survey.reload
			expect(survey.as_map(:no_ids => true)).to eq([{"text"=>"Question #1", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q1 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #2", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q2 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q2 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #3", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}, {"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}])

			# Link
			post 'link_next_question', {
				question_id: 14
			}.to_json, @header_params.merge(:answer_id => 7,:HTTP_ACCEPT_LANGUAGE => 'en')

			survey.reload
			expect(survey.as_map(:no_ids => true)).to eq([{"text"=>"Question #1", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q1 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #2", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q2 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q2 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q1 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}]}, {"text"=>"Q1 Answer #3", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}, {"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}])

			# Unlink
			delete 'unlink_next_question', {
			}.to_json, @header_params.merge(:answer_id => 8,:HTTP_ACCEPT_LANGUAGE => 'en')

			survey.reload
			expect(survey.as_map(:no_ids => true)).to eq([{"text"=>"Question #1", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q1 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #2", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q2 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q2 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}, {"text"=>"Q1 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}]}, {"text"=>"Q1 Answer #3", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}, {"text"=>"Question #3", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q3 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}, {"text"=>"Q3 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question #4", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Q4 Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Q4 Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[{"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}]}]}]}]}, {"text"=>"Question Linkable", :type=>"ActiveRecordSurvey::Node::Question", :children=>[{"text"=>"Question Linkable Answer #1", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}, {"text"=>"Question Linkable Answer #2", :type=>"ActiveRecordSurvey::Node::Answer", :children=>[]}]}])
		end

		it 'should not create bad links (infinite loops)' do
			survey = ActiveRecordSurvey::Survey.create()
			q1 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Q1", :survey => survey)
			q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 A1")
			q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 A2")
			q1_a3 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 A3")
			q1_a4 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 A4")
			q1.build_answer(q1_a1)
			q1.build_answer(q1_a2)
			q1.build_answer(q1_a3)
			q1.build_answer(q1_a4)

			q2 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Q2", :survey => survey)
			q2_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q2 A1")
			q2_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q2 A2")
			q2.build_answer(q2_a1)
			q2.build_answer(q2_a2)

			q3 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Q3", :survey => survey)
			q3_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 A1")
			q3_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 A2")
			q3.build_answer(q3_a1)
			q3.build_answer(q3_a2)

			q4 = survey.questions.build(:type => "ActiveRecordSurvey::Node::Question", :text => "Q4", :survey => survey)
			q4_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q4 A1")
			q4_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q4 A2")
			q4.build_answer(q4_a1)
			q4.build_answer(q4_a2)

			q1_a1.build_link(q3)
			q1_a2.build_link(q4)
			q1_a3.build_link(q3)
			q1_a4.build_link(q3)

			q2_a1.build_link(q1)
			q2_a2.build_link(q4)

			q3_a1.build_link(q4)
			q3_a2.build_link(q4)
			survey.save

			# Link
			post 'link_next_question', {
				question_id: q1.id
			}.to_json, @header_params.merge(:answer_id => q4_a1.id,:HTTP_ACCEPT_LANGUAGE => 'en')

			expect(response.code).to eq("508")
			expect(response.body).to eq('{"errors":[{"status":"508","code":"LOOP_DETECTED"}]}')
		end
	end

	describe 'GET index' do
		it 'should retrieve all answers for a question' do
			I18n.locale = :en

			survey = FactoryGirl.build(:basic_survey)
			survey.save

			expected_total_answers_at_index = [
				3,2,2,2
			]
			survey.questions.each_with_index { |question, index|
				get :index,
				{
				}.to_json, @header_params.merge(:question_id => question.id,:HTTP_ACCEPT_LANGUAGE => 'en')
				json_body = JSON.parse(response.body)

				expect(json_body["meta"]["total"]).to eq(expected_total_answers_at_index[index])
			}
		end
	end
	describe 'PUT update' do
		it 'should update answers in english and french' do
			survey = FactoryGirl.build(:basic_survey)
			survey.save

			# ------------------------------------------------------------------------------
			# Answers should be updateable in each language
			# ------------------------------------------------------------------------------

			I18n.locale = :en

			put :update,
			{
				:answer => {
					:attributes => {
						:text => "It's definitely a Monday."
					}
				}
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)
			
			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"It's definitely a Monday."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/2/relationships/next-question", "related"=>"/answers/2/next-question"}}}}})

			I18n.locale = :fr

			put :update,
			{
				:answer => {
					:attributes => {
						:text => "Il est certainement un lundi."
					}
				}
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'fr')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"Il est certainement un lundi."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/2/relationships/next-question", "related"=>"/answers/2/next-question"}}}}})

			# ------------------------------------------------------------------------------
			# Answers should be retrievable in each translated language
			# ------------------------------------------------------------------------------

			I18n.locale = :en

			get :show,
			{
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)
			
			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"It's definitely a Monday."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/2/relationships/next-question", "related"=>"/answers/2/next-question"}}}}})

			I18n.locale = :fr

			get :show,
			{
			}.to_json, @header_params.merge(:id => 2, :HTTP_ACCEPT_LANGUAGE => 'fr')
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"Il est certainement un lundi."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/2/relationships/next-question", "related"=>"/answers/2/next-question"}}}}})
			

			# ------------------------------------------------------------------------------
			# All answers should be retrievable in language for each question
			# ------------------------------------------------------------------------------

			I18n.locale = :en

			get :index,
			{
			}.to_json, @header_params.merge(:question_id => 1,:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)
			
			expected_answers = [
				"It's definitely a Monday.",
				"Q1 Answer #2",
				"Q1 Answer #3",
			]
			json_body["data"].each_with_index { |answer, index|
				expect(answer["attributes"]["text"]).to eq(expected_answers[index])
			}
			expect(json_body["meta"]["total"]).to eq(3)

			I18n.locale = :fr

			get :index,
			{
			}.to_json, @header_params.merge(:question_id => 1,:HTTP_ACCEPT_LANGUAGE => 'fr')
			json_body = JSON.parse(response.body)

			expected_answers = [
				"Il est certainement un lundi.",
				nil,
				nil,
			]
			json_body["data"].each_with_index { |answer, index|
				expect(answer["attributes"]["text"]).to eq(expected_answers[index])
			}
			#expect(json_body).to eq({"data"=>[{"id"=>"2", "type"=>"answer_answers", "attributes"=>{"text"=>"Il est certainement un lundi."}, "links"=>{"self"=>"/answers/2"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/2/relationships/question", "related"=>"/answers/2/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/2/relationships/next-question", "related"=>"/answers/2/next-question"}}}}, {"id"=>"11", "type"=>"answer_answers", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/answers/11"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/11/relationships/question", "related"=>"/answers/11/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/11/relationships/next-question", "related"=>"/answers/11/next-question"}}}}, {"id"=>"6", "type"=>"answer_answers", "attributes"=>{"text"=>nil}, "links"=>{"self"=>"/answers/6"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/6/relationships/question", "related"=>"/answers/6/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/6/relationships/next-question", "related"=>"/answers/6/next-question"}}}}], "meta"=>{"total"=>3}})
			expect(json_body["meta"]["total"]).to eq(3)

			I18n.locale = :en

			get :index,
			{
			}.to_json, @header_params.merge(:question_id => 5,:HTTP_ACCEPT_LANGUAGE => 'en')
			json_body = JSON.parse(response.body)

			expect(json_body["meta"]["total"]).to eq(2)
		end
	end

	describe 'POST create' do
		it 'should create new answers english', :workonme => true do
			survey = ActiveRecordSurvey::Survey.create

			# Question 1
			question1 = ActiveRecordSurvey::Node::Question.create(
				:text => "How are you doing today?",
				:survey => survey
			)

			# Question 2
			question2 = ActiveRecordSurvey::Node::Question.create(
				:text => "What food do you like?",
				:survey => survey
			)

			survey.save

			# Default answer type
			# Add Question 1 Answers
			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"

			post :create,
			{
				:answer => {
					:attributes => {
						:text => "Great!"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question1.id)

			post :create,
			{
				:answer => {
					:attributes => {
						:text => "Oh, you know, I'm OK."
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question1.id)

			post :create,
			{
				:answer => {
					:attributes => {
						:text => "It's definitely a Monday."
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question1.id)

			# Boolean answer type
			# Add Question 2 Answers
			request.headers[:HTTP_ACCEPT_LANGUAGE] = "en"

			post :create,
			{
				:answer => {
					:attributes => {
						:type => "boolean",
						:text => "Pizza"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question2.id)
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"6", "type"=>"boolean_answers", "attributes"=>{"text"=>"Pizza"}, "links"=>{"self"=>"/answers/6"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/6/relationships/question", "related"=>"/answers/6/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/6/relationships/next-question", "related"=>"/answers/6/next-question"}}}}})

			post :create,
			{
				:answer => {
					:attributes => {
						:type => "boolean",
						:text => "Spagetti"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question2.id)
			json_body = JSON.parse(response.body)
			expect(json_body).to eq({"data"=>{"id"=>"7", "type"=>"boolean_answers", "attributes"=>{"text"=>"Spagetti"}, "links"=>{"self"=>"/answers/7"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/7/relationships/question", "related"=>"/answers/7/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/7/relationships/next-question", "related"=>"/answers/7/next-question"}}}}})

			post :create,
			{
				:answer => {
					:attributes => {
						:type => "boolean",
						:text => "Nachos"
					}
				}
			}.to_json, @header_params.merge(:survey_id => survey.id, :question_id => question2.id)
			json_body = JSON.parse(response.body)

			expect(json_body).to eq({"data"=>{"id"=>"8", "type"=>"boolean_answers", "attributes"=>{"text"=>"Nachos"}, "links"=>{"self"=>"/answers/8"}, "relationships"=>{"question"=>{"links"=>{"self"=>"/answers/8/relationships/question", "related"=>"/answers/8/question"}}, "next-question"=>{"links"=>{"self"=>"/answers/8/relationships/next-question", "related"=>"/answers/8/next-question"}}}}})

			# As Map should
			expect(survey.as_map(:no_ids => true).as_json).to eq([
				{
				  "text" => "How are you doing today?",
				  "type" => "ActiveRecordSurvey::Node::Question",
				  "children" => [
					{
					  "text" => "Great!",
					  "type" => "ActiveRecordSurvey::Node::Answer",
					  "children" => [
					  ]
					},
					{
					  "text" => "Oh, you know, I'm OK.",
					  "type" => "ActiveRecordSurvey::Node::Answer",
					  "children" => [
			  
					  ]
					},
					{
					  "text" => "It's definitely a Monday.",
					  "type" => "ActiveRecordSurvey::Node::Answer",
					  "children" => [
			  
					  ]
					}
				  ]
				},
				{
				  "text" => "What food do you like?",
				  "type" => "ActiveRecordSurvey::Node::Question",
				  "children" => [
					{
					  "text" => "Pizza",
					  "type" => "ActiveRecordSurvey::Node::Answer::Boolean",
					  "children" => [
						{
						  "text" => "Spagetti",
						  "type" => "ActiveRecordSurvey::Node::Answer::Boolean",
						  "children" => [
							{
							  "text" => "Nachos",
							  "type" => "ActiveRecordSurvey::Node::Answer::Boolean",
							  "children" => [
			  
							  ]
							}
						  ]
						}
					  ]
					}
				  ]
				}
			])
		end
	end
end