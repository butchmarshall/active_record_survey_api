module ActiveRecordSurveyApi
	class QuestionSerializer < BaseSerializer
		attribute :text

		has_many :answers
		has_one :next_question
	end
end