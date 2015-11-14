module ActiveRecordSurveyApi
	class AnswerSerializer < BaseSerializer
		attribute :text

		has_one :question

		def type
			"#{object.class.name.demodulize.tableize.singularize.dasherize}_answers"
		end

		def self_link
			"/answers/#{id}"
		end
	end
end