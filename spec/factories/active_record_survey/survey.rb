module FactoryGirlSurveyHelpers
	extend self
	def build_basic_survey(survey)
		q1 = ActiveRecordSurvey::Node::Question.new(:text => "Question #1")
		survey.build_question(q1)
		q1_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #1")
		q1_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #2")
		q1_a3 = ActiveRecordSurvey::Node::Answer.new(:text => "Q1 Answer #3")
		q1.build_answer(q1_a1)
		q1.build_answer(q1_a2)
		q1.build_answer(q1_a3)

		q2 = ActiveRecordSurvey::Node::Question.new(:text => "Question #2")
		survey.build_question(q2)
		q2_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q2 Answer #1")
		q2_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q2 Answer #2")
		q2.build_answer(q2_a1)
		q2.build_answer(q2_a2)

		q3 = ActiveRecordSurvey::Node::Question.new(:text => "Question #3")
		survey.build_question(q3)
		q3_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 Answer #1")
		q3_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q3 Answer #2")
		q3.build_answer(q3_a1)
		q3.build_answer(q3_a2)

		q4 = ActiveRecordSurvey::Node::Question.new(:text => "Question #4")
		survey.build_question(q4)
		q4_a1 = ActiveRecordSurvey::Node::Answer.new(:text => "Q4 Answer #1")
		q4_a2 = ActiveRecordSurvey::Node::Answer.new(:text => "Q4 Answer #2")
		q4.build_answer(q4_a1)
		q4.build_answer(q4_a2)

		# Link up Q1
		q1_a1.build_link(q2)
		q1_a2.build_link(q3)
		q1_a3.build_link(q4)

		# Link up Q2
		q2_a1.build_link(q4)
		q2_a2.build_link(q3)

		# Link up Q3
		q3_a1.build_link(q4)
		q3_a2.build_link(q4)
	end
end

FactoryGirl.define do	
	factory :survey, :class => 'ActiveRecordSurvey::Survey' do |f|
		f.name "Survey"
	end

	factory :basic_survey, parent: :survey do |f|
		after(:build) { |survey| FactoryGirlSurveyHelpers.build_basic_survey(survey) }
	end
end