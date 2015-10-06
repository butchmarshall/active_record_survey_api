require_dependency "active_record_survey_api/application_controller"

module ActiveRecordSurveyApi
	class SurveysController < ApplicationController
		include Concerns::Controllers::Surveys

		def index
			@surveys = all_surveys

			render json: @surveys, each_serializer: SurveySerializer, meta: { total: @surveys.length }
		end

		def show
			@survey = survey_by_id(params[:id])

			render json: @survey, serializer: SurveySerializer
		end

		def create
			@survey = new_survey(survey_params)
			@survey.save

			render json: @survey, serializer: SurveySerializer
		end
	end
end
