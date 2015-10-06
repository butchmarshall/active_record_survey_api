module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Surveys
				extend ActiveSupport::Concern

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