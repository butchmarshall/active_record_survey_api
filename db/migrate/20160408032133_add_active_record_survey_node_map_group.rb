class AddActiveRecordSurveyNodeMapGroup < ActiveRecord::Migration
	def up
		require "generators/active_record_survey/node_map_group/templates/migration_0.0.1"
		AddActiveRecordSurveyNodeMapGroup.up
	end
	
	def down
		require "generators/active_record_survey/node_map_group/templates/migration_0.0.1"
		AddActiveRecordSurveyNodeMapGroup.down
	end
end
