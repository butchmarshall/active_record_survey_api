require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module Instances
			extend ActiveRecordSurveyApi::Concerns::Controllers::Instances
		end
	end
end

module ActiveRecordSurveyApi
	class InstancesController < ApplicationController
		include Concerns::Controllers::Instances
	end
end
