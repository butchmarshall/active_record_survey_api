module ActiveRecordSurveyApi
	class QuestionSerializer < BaseSerializer
		attribute :text

		has_many :answers
	end
end