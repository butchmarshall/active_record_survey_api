require 'jsonapi-serializers'

module ActiveRecordSurveyApi
	class BaseSerializer #< ActiveModel::Serializer
		include JSONAPI::Serializer
		#include Rails.application.routes.url_helpers
	end
end