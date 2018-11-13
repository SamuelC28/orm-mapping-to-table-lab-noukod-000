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

# ..............
def self.all_students_in_grade_9
   sql = <<-SQL
   SELECT * FROM students
   WHERE grade = ?
   SQL

   DB[:conn].execute(sql,"9").map do |row|
     create row
   end
 end

 def self.students_below_12th_grade
   sql = <<-SQL
   SELECT * FROM students
   WHERE grade < ?
   SQL

   DB[:conn].execute(sql,"12").map do |row|
     create row
   end
 end

 def self.first_X_students_in_grade_10 x
   sql = <<-SQL
   SELECT * FROM students WHERE grade = ?
   SQL

   DB[:conn].execute(sql,10)[0,x]
 end

 def self.first_student_in_grade_10
   sql = <<-SQL
   SELECT * FROM students WHERE grade = ?
   ORDER BY id LIMIT 1
   SQL

   create DB[:conn].execute(sql,10)[0]
 end

 def self.all_students_in_grade_X x
   sql = <<-SQL
   SELECT * FROM students WHERE grade = ?
   SQL

   DB[:conn].execute(sql,x).map do |row|
     create row
   end
end
# ....................
def self.find_by_name(name)
  sql = <<-SQL
  SELECT * FROM students WHERE name = ?
  SQL

  DB[:conn].execute(sql,name).map do |row|
    create(row)
  end.first
end

def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
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
