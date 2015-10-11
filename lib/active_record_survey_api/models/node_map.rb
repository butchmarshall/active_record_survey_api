module ActiveRecordSurveyApi
	module Models
		module NodeMap
			def self.included(base)
				base.instance_eval do
					include InstanceMethods
				end
				base.class_eval do
					alias_method_chain :as_map, :text
				end
			end
			module InstanceMethods
				def as_map_with_text(node_maps = nil)
					result = {
						"text" => self.node.text
					}
					result = result.merge(as_map_without_text(node_maps))

					result
				end
			end
		end
	end
end