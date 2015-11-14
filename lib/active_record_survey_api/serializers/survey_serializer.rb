module ActiveRecordSurveyApi
	class SurveySerializer < BaseSerializer
		attribute :name
		#attribute :links
	
		#has_many :node_maps
		#def links
		#	{
		#		"self" => survey_path(object)
		#	}
		#end
	end
end