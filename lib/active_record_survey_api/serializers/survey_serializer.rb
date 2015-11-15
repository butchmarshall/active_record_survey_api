module ActiveRecordSurveyApi
	class SurveySerializer < BaseSerializer
		attribute :name

		has_many :questions

		def self_link
			url_helpers.survey_path(id)
		end
	end
end