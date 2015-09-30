require_dependency "active_record_survey_api/application_controller"

module ActiveRecordSurveyApi
	class SurveysController < ApplicationController
		def index
			@surveys = ::ActiveRecordSurvey::Survey.all

			render json: @surveys, each_serializer: SurveySerializer
		end

		def show
			@survey = ::ActiveRecordSurvey::Survey.find(params[:id])

			render json: @survey, serializer: SurveySerializer
		end
	end
end
