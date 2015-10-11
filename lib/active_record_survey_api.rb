require "http_accept_language"
require "active_record_survey"
require "active_model_serializers"
require "globalize"

require "active_record_survey_api/engine"

require "active_record_survey_api/concerns/controllers/surveys"
require "active_record_survey_api/concerns/controllers/questions"
require "active_record_survey_api/concerns/controllers/answers"
require "active_record_survey_api/concerns/controllers/node_maps"
require "active_record_survey_api/concerns/controllers/nodes"

require "active_record_survey_api/models/node"
require "active_record_survey_api/models/node_map"
require "active_record_survey_api/models/node/question"
require "active_record_survey_api/models/node/answer"

module ActiveRecordSurveyApi
end

ActiveRecordSurvey::Node.send(:include, ActiveRecordSurveyApi::Models::Node)
ActiveRecordSurvey::NodeMap.send(:include, ActiveRecordSurveyApi::Models::NodeMap)
ActiveRecordSurvey::Node::Question.send(:include, ActiveRecordSurveyApi::Models::Node::Question)
ActiveRecordSurvey::Node::Answer.send(:include, ActiveRecordSurveyApi::Models::Node::Answer)

