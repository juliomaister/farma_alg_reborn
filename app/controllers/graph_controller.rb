class GraphController < ApplicationController
  def search_answers
    date_range = params[:date_range] ? params[:date_range].split("_") : []
    answers = Answer.by_team(params[:team_id]).by_user(params[:users])
                                   .by_question(params[:questions])
                                   .between_dates(date_range[0], date_range[1])
                                   .by_key_words(params[:key_words])

    @answers = answers.each.inject([]) { |array, answer|
                 array << answer_object_to_graph(answer)
              }

    respond_to { |format| format.js }
  end

  def connections
    target_answer = Answer.find(params[:target_answer])

    connections = params[:all_answers] ? target_answer.answer_connections :
                                         target_answer.connections_with(params[:answers])

    @connections = connections.each.inject([]) do |array, connection|
      hash = {}
      hash.merge!(connection.slice(:id, :similarity).symbolize_keys)

      connection.slice(:answer_1, :answer_2).each do |answer|
        answer_key = answer[0].to_sym
        answer_obj = answer[1]
        hash[answer_key] = answer_object_to_graph(answer_obj)
      end

      array << hash
    end

    respond_to { |format| format.json { render json: @connections } }
  end

    private

    # Get answer data used in views.
    def answer_data(answer)
      answer.slice(:id, :content, :correct, :compilation_error,
                               :compiler_output, :created_at).symbolize_keys
    end

    # Get user data used in views.
    def user_data(user)
      user.slice(:id, :name).symbolize_keys
    end

    # Get exercise data used in views.
    def exercise_data(exercise)
      exercise.slice(:id, :title).symbolize_keys
    end

    # Get question data used in views.
    def question_data(question)
      question.slice(:id, :title).symbolize_keys
    end

    # Create a hash with the necessary data to display in the graph.
    def answer_object_to_graph(answer)
      hash = {}
      hash.merge!(answer_data(answer))
      hash[:user] = user_data(answer.user)
      hash[:question] = question_data(answer.question)
      hash[:exercise] = exercise_data(answer.question.exercise)
      hash
    end

end