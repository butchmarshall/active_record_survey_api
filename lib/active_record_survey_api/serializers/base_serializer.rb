require 'jsonapi-serializers'

module ActiveRecordSurveyApi
	class BaseSerializer #< ActiveModel::Serializer
		include JSONAPI::Serializer
		delegate :url_helpers, to: 'ActiveRecordSurveyApi::Engine.routes' 
	end
end