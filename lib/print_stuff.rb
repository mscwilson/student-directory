class PrintStuff

  attr_reader :students

  def initialize(students)
    @students = students
  end

  def print_welcome
    puts "Welcome to the Villains Academy Student Management Portal".center(100)
    puts "-------------".center(100)
  end

  def show_students
    print_header
    print_student_names
    print_footer
  end

  def print_header
    puts "The students of Villains Academy".center(100)
    puts "-------------".center(100)
  end

  def print_student_names
    return if students.empty?
    loop do
      puts "How would you like to display the names? Please choose by number."
      puts "1. In the order they were entered"
      puts "2. By cohort"
      puts "3. Display only students whose names begin with a certain letter"

      input = STDIN.gets.chomp
      if input == "1"
        print_by_entered_order
        break
      elsif input == "2"
        print_by_cohort
        break
      elsif input == "3"
        print_with_chosen_letter
        break
      else
        puts "That's not a valid choice."
      end
    end
  end

  def print_by_entered_order
    puts "These are all the enrolled students:"
    students.each_with_index do |student, i|
      print "#{i + 1}.".center(4)
      puts "#{students[i][:name]} (#{students[i][:cohort]} cohort)"
    end
  end

  def print_with_chosen_letter
    puts "Which names are you interested in? Please enter a letter."
    input = STDIN.gets.chomp
    puts "Here are the students beginning with: #{input[0].upcase}"
    students.each_with_object(names = []) do |student, arr|
      if student[:name][0].downcase == input[0].downcase
        puts "#{student[:name]} (#{student[:cohort]} cohort)"
        arr << student[:name] # storing the names here so can check if there were any, for the following puts line
      end
    end
    puts "Sorry, no students have names beginning with that character." if names.empty?
  end

  def print_by_cohort
    puts "These are all the enrolled students, listed by cohort:"
    students.each_with_object(cohorts_list = []) { |dict, arr| arr << dict[:cohort]}
    cohorts_list.uniq!.each do |month|
      puts "#{month} cohort:"
      students.each { |student| puts "- #{student[:name]}" if student[:cohort] == month }
      puts
    end
  end

  def print_footer
    if students.empty?
      puts "No students are enrolled."
    else
      puts students.length == 1 ? "In total, we have #{students.length} great student." : "In total, we have #{students.length} great students."
    end
  end

end
