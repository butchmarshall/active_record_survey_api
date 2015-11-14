require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module Answers
			extend ActiveRecordSurveyApi::Concerns::Controllers::Answers
		end
	end
end

module ActiveRecordSurveyApi
	class AnswersController < ApplicationController
		include Concerns::Controllers::Answers
	end
end
