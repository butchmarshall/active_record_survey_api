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

		def index
			@answers = all_answers

			render json: @answers, each_serializer: AnswerSerializer, meta: { total: @answers.length }
		end

		def show
			@answer = answer_by_id(params[:id])

			render json: @answer, serializer: AnswerSerializer
		end

		def create
			@answer = new_answer(answer_params)
			@question.build_answer(@answer, @survey)
			@survey.save

			render json: @answer, serializer: AnswerSerializer
		end
	end
end
