module ActiveRecordSurveyApi
	class AnswerSerializer < BaseSerializer
		attribute :text
		#attribute :next_question_id do
		#	i = object.next_question
		#	((i)? i.id.to_s : nil)
		#end

		has_one :question
		has_one :next_question

		def type
			"#{object.class.name.demodulize.tableize.singularize.dasherize}_answers"
		end

		def self_link
			url_helpers.answer_path(id)
		end
	end
end