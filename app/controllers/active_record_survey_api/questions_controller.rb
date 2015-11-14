require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module Questions
			extend ActiveRecordSurveyApi::Concerns::Controllers::Questions
		end
	end
end

module ActiveRecordSurveyApi
	class QuestionsController < ApplicationController
		include Concerns::Controllers::Questions
	end
end
