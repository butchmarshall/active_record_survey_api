class SurveySerializer < ActiveModel::Serializer
	attributes :id, :name

	#has_many :node_maps
end
