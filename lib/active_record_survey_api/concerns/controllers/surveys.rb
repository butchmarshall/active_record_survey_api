module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Surveys
				extend ActiveSupport::Concern

				def index
					@surveys = all_surveys

					render json: serialize_models(@surveys, serializer: ActiveRecordSurveyApi::SurveySerializer, meta: { total: @surveys.length })
				end

				def show
					@survey = survey_by_id(params[:id])

					render json: serialize_model(@survey, serializer: ActiveRecordSurveyApi::SurveySerializer)
				end

				def destroy
					@survey = survey_by_id(params[:id])
					@survey.destroy

					head :no_content
				end

				def update
					@survey = survey_by_id(params[:id])
					@survey.update_attributes(survey_params)

					render json: serialize_model(@survey, serializer: ActiveRecordSurveyApi::SurveySerializer)
				end

				def create
					@survey = new_survey(survey_params)
					@survey.save

					#render json: @survey, serializer: SurveySerializer
					render json: serialize_model(@survey, serializer: ActiveRecordSurveyApi::SurveySerializer)
				end

				def edges
					@survey = survey_by_id(params[:survey_id])

					render json: @survey.edges
				end

				def nodes
					@survey = survey_by_id(params[:survey_id])

					nodes = @survey.nodes.includes(:translations)
					questions = nodes.select { |i|
						i.class.ancestors.include?(::ActiveRecordSurvey::Node::Question)
					}
					answers = nodes.select { |i|
						i.class.ancestors.include?(::ActiveRecordSurvey::Node::Answer)
					}

					questions = serialize_models(questions, serializer: ActiveRecordSurveyApi::QuestionSerializer, meta: { total: questions.length })
					answers = serialize_models(answers, serializer: ActiveRecordSurveyApi::AnswerSerializer, meta: { total: answers.length })

					render json: { questions: questions, answers: answers }
				end

				private 
					def all_surveys
						ActiveRecordSurvey::Survey.all
					end

					def survey_by_id(id)
						ActiveRecordSurvey::Survey.find(id)
					end

					def new_survey(params)
						ActiveRecordSurvey::Survey.new(survey_params)
					end

					def json_params
						ActionController::Parameters.new(JSON.parse(request.body.read))
					end

					def survey_params
						json_params.require(:survey).require(:attributes).permit(:name)
					end
			end
		end
	end
end