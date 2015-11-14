require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module InstanceNodes
			extend ActiveRecordSurveyApi::Concerns::Controllers::InstanceNodes
		end
	end
end

module ActiveRecordSurveyApi
	class InstanceNodesController < ApplicationController
		include Concerns::Controllers::InstanceNodes
	end
end
