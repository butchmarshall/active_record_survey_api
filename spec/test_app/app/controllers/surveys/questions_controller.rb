
module Concerns
	module Controllers
		module Surveys
			module Questions
				extend ActiveRecordSurveyApi::Concerns::Controllers::Surveys::Questions

			end
		end
	end
end

class Surveys::QuestionsController < ::ActiveRecordSurvey::SurveysController
	include Concerns::Controllers::Surveys::Questions
end