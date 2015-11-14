require "http_accept_language"
require "active_record_survey"
require "globalize"

require "active_record_survey_api/engine"

require "active_record_survey_api/concerns/controllers/surveys"
require "active_record_survey_api/concerns/controllers/questions"
require "active_record_survey_api/concerns/controllers/answers"
require "active_record_survey_api/concerns/controllers/node_maps"
require "active_record_survey_api/concerns/controllers/nodes"
require "active_record_survey_api/concerns/controllers/instances"
require "active_record_survey_api/concerns/controllers/instance_nodes"

require "active_record_survey_api/models/node"
require "active_record_survey_api/models/node_map"
require "active_record_survey_api/models/node/question"
require "active_record_survey_api/models/node/answer"
require "active_record_survey_api/models/instance"

require "active_record_survey_api/serializers/base_serializer"
require "active_record_survey_api/serializers/answer_serializer"
require "active_record_survey_api/serializers/instance_serializer"
require "active_record_survey_api/serializers/instance_node_serializer"
require "active_record_survey_api/serializers/node_map_serializer"
require "active_record_survey_api/serializers/node_serializer"
require "active_record_survey_api/serializers/question_serializer"
require "active_record_survey_api/serializers/survey_serializer"

module ActiveRecordSurveyApi
end

ActiveRecordSurvey::Node.send(:include, ActiveRecordSurveyApi::Models::Node)
ActiveRecordSurvey::NodeMap.send(:include, ActiveRecordSurveyApi::Models::NodeMap)
ActiveRecordSurvey::Node::Question.send(:include, ActiveRecordSurveyApi::Models::Node::Question)
ActiveRecordSurvey::Node::Answer.send(:include, ActiveRecordSurveyApi::Models::Node::Answer)
ActiveRecordSurvey::Instance.send(:include, ActiveRecordSurveyApi::Models::Instance)

# Fallback support
#require "i18n/backend/fallbacks" 
#I18n.fallbacks.map('es' => 'en')