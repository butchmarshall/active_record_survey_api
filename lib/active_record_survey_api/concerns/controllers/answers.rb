module ActiveRecordSurveyApi
	module Concerns
		module Controllers
			module Answers
				extend ActiveSupport::Concern

				included do
					before_filter :find_survey, :if => proc { |c| params[:survey_id].to_i > 0 }
					before_filter :find_question, :if => proc { |c| params[:question_id].to_i > 0 }
					before_filter :find_answer, :if => proc { |c| params[:answer_id].to_i > 0 }
				end

				def update
					answer_params.delete(:type) unless answer_params[:type].nil?  # cannot set type through update

					@answer = answer_by_id(params[:id])
					@answer.update_attributes(answer_params)

					render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
				end

				def index
					@answers = all_answers

					render json: serialize_models(@answers, serializer: ActiveRecordSurveyApi::AnswerSerializer, meta: { total: @answers.length })
				end
		
				def show
					@answer = answer_by_id(params[:id])

					render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
				end

				def destroy
					@answer = answer_by_id(params[:id])
					@answer.destroy

					head :no_content
				end

				def create
					@answer = new_answer(answer_params)

					begin
						@question.build_answer(@answer)
						@question.survey.save
					rescue Exception => $e
						render json: {
							errors: [
								{
									status: "400",
									code: "CANNOT_MIX_ANSWER_TYPE"
								}
							]
						}, status: :bad_request
					else
						render json: serialize_model(@answer, serializer: ActiveRecordSurveyApi::AnswerSerializer)
					end
				end

				def get_next_question
					@answer = answer_by_id(params[:answer_id])
					@question = @answer.next_question

					render json: serialize_model(@question, serializer: ActiveRecordSurveyApi::QuestionSerializer)
				end

				def link_next_question
					@answer = answer_by_id(params[:answer_id])
					@question = ActiveRecordSurvey::Node::Question.find(json_params[:question_id])

					if !@answer.next_question.nil?
						@answer.remove_link
					end

					begin
						@answer.build_link(@question)
						@question.survey.save
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
					@answer = answer_by_id(params[:answer_id])
					@answer.remove_link
					@answer.save

					head :no_content
				end

				private
					def all_answers
						all_answers = []
						all_answers = @question.answers if !@question.nil?
						all_answers
					end

					def answer_by_id(id)
						ActiveRecordSurvey::Node::Answer.find(id)
					end

					def new_answer(params)
						klass = "#{(params[:type] || "::ActiveRecordSurvey::Node::Answer")}".constantize

						klass.new(params)
					end

					def json_params
						ActionController::Parameters.new(JSON.parse(request.body.read))
					end

					def answer_params
						json_params.require(:answer).require(:attributes).permit(:text,:type,:sibling_index,"sibling-index".to_sym).tap { |whitelisted|
							whitelisted[:sibling_index] = whitelisted["sibling-index".to_sym].to_i unless whitelisted["sibling-index".to_sym].nil?
							whitelisted[:type] = "ActiveRecordSurvey::Node::Answer#{ ((whitelisted[:type].to_s.empty?) ? "" : "::") }#{whitelisted[:type].camelize}" unless whitelisted[:type].nil?

							whitelisted.delete("sibling-index".to_sym)
						}
					end

					def find_survey
						self.instance_variable_set "@survey", ActiveRecordSurvey::Survey.find(params[:survey_id])
					end

					def find_question
						self.instance_variable_set "@question", ActiveRecordSurvey::Node::Question.find(params[:question_id])
					end

					def find_answer
						self.instance_variable_set "@answer", ActiveRecordSurvey::Node::Answer.find(params[:answer_id])
					end
			end
		end
	end
end