class AddGlobalize < ActiveRecord::Migration
	def up
		add_column ::ActiveRecordSurvey::Survey.arel_table, :name, :string, :default => ''

		::ActiveRecordSurveyApi::Node.create_translation_table!(
			:text => {
				:type => :string,
				:null => false,
				:default => '',
			}
		)
	end

	def down
		remove_column ::ActiveRecordSurvey::Survey.arel_table, :name
		::ActiveRecordSurveyApi::Node.drop_translation_table!
	end
end
