class Student
  attr_accessor :name, :grade
  attr_reader :id
  #
  def initialize(name, grade)
    @name = name
    @grade = grade
    # @id = id
  end

  def self.create(name:, grade:)
    new_student = new(name, grade)
    new_student.save
    new_student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      create row
    end
   end


  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end
  #
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
