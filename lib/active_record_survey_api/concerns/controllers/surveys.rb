module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Surveys
				extend ActiveSupport::Concern

				def index
					@surveys = all_surveys

					#render json: @surveys, each_serializer: SurveySerializer, meta: { total: @surveys.length }
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
						json_params.require(:survey).permit(:name, nodes: [])
					end
			end
		end
	end
end