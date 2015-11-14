module ActiveRecordSurveyApi
	class NodeMapSerializer < BaseSerializer
		attribute :node_id
		attribute :parent_id

		def node_id
			object.active_record_survey_node_id
		end
	end
end