require_relative 'questions_database'
require_relative 'reply'
require_relative 'question_follow'
require_relative 'question_like'

class Question

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    return nil if question.empty?
    Question.new(question.first)
  end

  def self.id_exists?(id)
    !Question.find_by_id(id).nil?
  end

  def self.find_by_author_id(author_id)
    user = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    raise "User #{author_id} does not exist" if user.empty?

    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    questions.map { |question| Question.new(question) }
  end

  attr_accessor :subject, :body, :user_id
  attr_reader :id

  def initialize(options)
    @id = options['id']
    @subject = options['subject']
    @body = options['body']
    @user_id = options['user_id']
  end

  def author
    user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL

    User.new(user.first)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

  def likers
    QuestionLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end

end
