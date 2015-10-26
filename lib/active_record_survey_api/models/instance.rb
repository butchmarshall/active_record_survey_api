module ActiveRecordSurveyApi
	module Models
		module Instance
			def self.included(base)
				base.class_eval do
					accepts_nested_attributes_for :instance_nodes
				end
			end
		end
	end
end