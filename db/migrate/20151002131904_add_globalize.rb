class AddGlobalize < ActiveRecord::Migration
	def up
		require "generators/active_record_survey/templates/migration_0.1.0"
		require "generators/active_record_survey/templates/migration_0.1.26"

		AddActiveRecordSurvey.up
		Update_0_1_26_ActiveRecordSurvey.up

		add_column ::ActiveRecordSurvey::Survey.arel_table, :name, :string, :default => ''

		::ActiveRecordSurvey::Node.create_translation_table!(
			:text => {
				:type => :string,
				:null => false,
				:default => '',
			}
		)
	end

	def down
		remove_column ::ActiveRecordSurvey::Survey.arel_table, :name
		::ActiveRecordSurvey::Node.drop_translation_table!
	end
end
