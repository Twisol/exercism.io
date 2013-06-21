class Assignments

  attr_reader :key, :curriculum
  def initialize(key, curriculum = Exercism.current_curriculum)
    @key = key
    @curriculum = curriculum
  end

  def user
    @user ||= User.find_by(key: key)
  end

  def current
    @current ||= assigned_exercises
  end

  def next
    @next ||= upcoming_exercises
  end

  private

  def assigned_exercises
    user.current_exercises.map do |exercise|
      unless exercise.slug == 'congratulations'
        curriculum.assign(exercise)
      end
    end.compact
  end

  def upcoming_exercises
    user.current_exercises.map do |exercise|
      next if exercise.slug == 'congratulations'
      exercise = curriculum.in(exercise.language).after(exercise)
      next if exercise.slug == 'congratulations'
      curriculum.assign(exercise)
    end
  end
end
