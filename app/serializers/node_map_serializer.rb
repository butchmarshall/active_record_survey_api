class NodeMapSerializer < ActiveModel::Serializer
	attributes :id, :node_id, :parent_id

	def node_id
		object.active_record_survey_node_id
	end
end
