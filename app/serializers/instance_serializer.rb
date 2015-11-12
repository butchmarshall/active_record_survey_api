class InstanceSerializer < ActiveModel::Serializer
	#attributes :survey_id
	belongs_to :survey, serializer: SurveySerializer

	#def survey_id
	#	object.active_record_survey_id
	#end
end
