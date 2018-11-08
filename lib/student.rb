require_relative "../config/environment.rb"

class Student
	def self.create_table
		DB[:conn].execute(<<-SQL
			CREATE TABLE IF NOT EXISTS students(
				id INTEGER PRIMARY KEY,
				name TEXT,
				grade TEXT
			)
			SQL
		)
	end

	def self.drop_table
		DB[:conn].execute("DROP TABLE IF EXISTS students")
	end

	def self.create(name, grade)
		DB[:conn].execute("INSERT INTO students(name, grade) VALUES (?, ?)", name, grade)
	end

	def self.new_from_db(row)
		Student.new(row[1], row[2], row[0])
	end

	def self.find_by_name(name)
		DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).map do |row|
			self.new_from_db(row)
		end.first
	end

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
  	@name = name
  	@grade = grade
  	@id = id
  end

  def save
  	if self.id
  		self.update
  	else
  		DB[:conn].execute("INSERT INTO students(name, grade) VALUES(?, ?)", self.name, self.grade)

  		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  	end
  end

  def update
  	DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
  end
end
