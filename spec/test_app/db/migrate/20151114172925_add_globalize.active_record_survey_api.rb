# This migration comes from active_record_survey_api (originally 20151002131904)
class AddGlobalize < ActiveRecord::Migration
	def up
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
