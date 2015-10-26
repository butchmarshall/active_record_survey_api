class InstanceSerializer < ActiveModel::Serializer
	attributes :survey_id

	def survey_id
		object.active_record_survey_id
	end
end
