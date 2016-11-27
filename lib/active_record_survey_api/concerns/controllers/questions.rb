module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Questions
				extend ActiveSupport::Concern

				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
				end

				def index
					@questions = all_questions

					render json: serialize_models(@questions, serializer: ActiveRecordSurveyApi::QuestionSerializer, meta: { total: @questions.length })
				end

				def show
					@question = question_by_id(params[:id])

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def destroy
					@question = question_by_id(params[:id])
					@question.destroy

					head :no_content
				end

				def update
					@question = question_by_id(params[:id])
					if !question_params[:type].nil?
						begin
							@question.update_question_type(question_params[:type].to_s.constantize)
							@question.survey.save
						rescue Exception => $e
							render json: {
								errors: [
									{
										status: "422",
										code: "422"
									}
								]
							}, status: :loop_detected
							return
						end
					end

					@question.update_attributes(question_params.except(:type))

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def create
					question_params.delete(:type) unless question_params[:type].nil?  # cannot set type through create

					@question = new_question(question_params)
					@question.survey = @survey
					@question.save

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def get_next_question
					@question = question_by_id(params[:question_id])
					@questions = @question.next_questions

					render json: serialize_models(@questions, serializer: ActiveRecordSurveyApi::QuestionSerializer, meta: { total: @questions.length })
				end

				def link_next_question
					@question_from = question_by_id(params[:question_id])
					@question_to = question_by_id(json_params[:question_id])

					if @question_from.next_questions.length > 0
						@question_from.remove_link
					end

					begin
						@question_from.build_link(@question_to)
						@question_from.survey.save
					rescue Exception => $e
						render json: {
							errors: [
								{
									status: "508",
									code: "LOOP_DETECTED"
								}
							]
						}, status: :loop_detected
					else
						head :no_content
					end
				end

				def unlink_next_question
					@question = question_by_id(params[:question_id])
					@question.remove_link
					@question.survey.save

					head :no_content
				end

				private
					def all_questions
						all_questions = []
						all_questions = @survey.questions if !@survey.nil?
						all_questions
					end

					def question_by_id(id)
						ActiveRecordSurvey::Node::Question.find(id)
					end

					def new_question(params)
						ActiveRecordSurvey::Node::Question.new(params, :survey => @survey)
					end

					def json_params
						ActionController::Parameters.new(JSON.parse(request.body.read))
					end

					def question_params
						json_params.require(:question).require(:attributes).permit(:text,:type).tap { |whitelisted|
							whitelisted[:type] = "ActiveRecordSurvey::Node::Answer#{ ((whitelisted[:type].to_s.empty?) ? "" : "::") }#{whitelisted[:type].camelize}" unless whitelisted[:type].nil?
						}
					end

					def find_survey
						self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
					end
			end
		end
	end
end