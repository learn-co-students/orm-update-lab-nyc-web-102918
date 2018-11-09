require('pry')
require_relative "../config/environment.rb"
class Student
  attr_accessor :id, :name, :grade
  def initialize(id=nil,name,grade)
    @id=id
    @name=name
    @grade=grade
  end

  def self.create_table
    sql= <<-SQL
    CREATE TABLE students
    (id INTEGER PRIMARY KEY,
      name TEXT
      grade INTEGER)
      SQL
      DB[:conn].execute(sql)
    end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if self.id
          self.update
    else
      sql="INSERT INTO students(name,grade) VALUES (?,?)"
      DB[:conn].execute(sql,self.name,self.grade)
      self.id=DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1").flatten[0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name,age)
    Student.new(name,age).save
  end

  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    sql="SELECT * from students WHERE name = ? LIMIT 1"
    data=DB[:conn].execute(sql,name)
    Student.new_from_db(data[0])
  end


end
