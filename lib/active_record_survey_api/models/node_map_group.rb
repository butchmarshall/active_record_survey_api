module ActiveRecordSurveyApi
	module Models
		module NodeMapGroup
			def self.included(base)
				base.class_eval do
					translates :text
				end
				
				def build_from_questions=questions
					self.build_questions(questions)
				end
			end
		end
	end
end