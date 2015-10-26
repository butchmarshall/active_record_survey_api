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

		def index
			@questions = all_questions

			render json: @questions, each_serializer: QuestionSerializer, meta: { total: @questions.length }
		end

		def show
			@question = question_by_id(params[:id])

			render json: @question, serializer: QuestionSerializer
		end

		def create
			@question = new_question(question_params)
			@survey.build_question(@question)
			@survey.save

			render json: @question, serializer: QuestionSerializer
		end
	end
end
