require_relative "file_manager"
require_relative "create_student"
require_relative "print_stuff"

class InteractiveMenu

  def interactive_menu(students)
    loop do
      print_menu
      process(students, STDIN.gets.chomp)
    end
  end

  def print_menu
    puts # an empty line to space things out a bit
    puts "What would you like to do?"
    puts "1. Input students"
    puts "2. Show the students"
    puts "3. Save the student list"
    puts "4. Load saved students list"
    puts "10. Exit"
  end

def process(students, selection)
  case selection
  when "1"
    puts "You have chosen to enter students."
    CreateStudent.new.input_students(students)
  when "2"
    puts "You have chosen to view the current students."
    PrintStuff.new(students).show_students
  when "3"
    puts "You have chosen to save the current students to file."
    FileManager.new.save_students(students)
  when "4"
    puts "You have chosen to load a saved students file."
    FileManager.new.load_students(students)
  when "10"
    puts "See you next time!"
    exit
  else
    puts "Not a valid choice! Please choose again."
  end
end

end
