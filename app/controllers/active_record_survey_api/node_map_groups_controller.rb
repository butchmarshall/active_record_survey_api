require_dependency "active_record_survey_api/application_controller"

module Concerns
	module Controllers
		module NodeMapGroups
			extend ActiveRecordSurveyApi::Concerns::Controllers::NodeMapGroups
		end
	end
end

module ActiveRecordSurveyApi
	class NodeMapGroupsController < ApplicationController
		include Concerns::Controllers::NodeMapGroups
	end
end
