require_relative "interactive_menu"
require_relative "file_manager"
require_relative "print_stuff"

class Directory

  def initialize
    @students = [] 
  end

  def run
    PrintStuff.new(@students).print_welcome
    FileManager.new.try_load_students(@students)
    InteractiveMenu.new.interactive_menu(@students)
  end

end

Directory.new.run




