class AddActiveRecordSurveyNodeMapGroupGlobalize < ActiveRecord::Migration
	def up
		::ActiveRecordSurvey::NodeMapGroup.create_translation_table!(
			:text => {
				:type => :string,
				:null => false,
				:default => '',
			}
		)
	end
	
	def down
		::ActiveRecordSurvey::NodeMapGroup.drop_translation_table!
	end
end
