module ActiveRecordSurveyApi
	class InstanceSerializer < BaseSerializer
		attribute :survey_id

		attribute :survey_id do
			object.active_record_survey_id
		end

		#belongs_to :survey
	end
end