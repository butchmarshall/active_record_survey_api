require_dependency "active_record_survey_api/application_controller"

module ActiveRecordSurveyApi
	class SurveysController < ApplicationController
		include Concerns::Controllers::Surveys
	end
end
