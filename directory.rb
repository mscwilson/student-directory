require "csv"
@students = []


def create_student(full_name, cohort = Time.now.strftime("%B").to_sym)
  # Default cohort is the current month
  @students << {name: full_name, cohort: cohort}
end

def input_students
  puts "Please enter the names of the students.\nYou can optionally specify the cohort if it's not the current month - separate the cohort from the name with a comma. Full or abbreviated month names are both fine."
  puts "To finish, just hit return twice"
  full_input = STDIN.gets.delete!("\n")

# A hash of months and their abbreviations. The values are arrays so that September could be abbreviated to Sep or Sept, because Sep seems weird to me
  months = {January: ["Jan"], February: ["Feb"], March: ["Mar"], April: ["Apr"], May: ["May"], June: ["Jun"], July: ["Jul"],
            August: ["Aug"], September: ["Sept", "Sep"], October: ["Oct"], November: ["Nov"], December: ["Dec"]}
  
  while !full_input.empty? do
    full_name, cohort = full_input.split(", ").map(&:capitalize!) # this will capitalise both month and name. Annoying to anyone who deliberately uses a lower case name
    if cohort != nil && months.include?(cohort.to_sym) # Checking for month full name in hash keys
      create_student(full_name, cohort.to_sym)
    elsif cohort != nil && months.any? { |k, v| v.include?(cohort) } # Checking for month abbreviated name in hash values
      unabbreviated_month = months.find { |k, v| v.include?(cohort) }
      create_student(full_name, unabbreviated_month[0])
    else 
      create_student(full_name) # If a month isn't provided, the default cohort is used
    end

    if @students.length == 1
      puts "Now we have #{@students.length} student"
    else
      puts "Now we have #{@students.length} students"
    end
    full_input = STDIN.gets.chomp
  end
  @students
end

def print_header
  puts "The students of Villains Academy".center(100)
  puts "-------------".center(100)
end

def print_student_names
  return if @students.empty?
  loop do
    puts "How would you like to display the names? Please choose by number."
    puts "1. In the order they were entered"
    puts "2. By cohort"
    puts "3. Display only students whose names begin with a certain letter"
    input = STDIN.gets.chomp

    if input == "1"
      puts "These are all the enrolled students:"
      @students.each_with_index do |student, i|
        print "#{i + 1}.".center(4)
        puts "#{@students[i][:name]} (#{@students[i][:cohort]} cohort)"
      end
      break

    elsif input == "2"
      puts "These are all the enrolled students, listed by cohort:"
      @students.each_with_object(cohorts_list = []) { |dict, arr| arr << dict[:cohort]}
      cohorts_list.uniq!.each do |month|
        puts "#{month} cohort:"
        @students.each { |student| puts "- #{student[:name]}" if student[:cohort] == month }
        puts
      end
      break

    elsif input == "3"
      puts "Which names are you interested in? Please enter a letter."
      input = STDIN.gets.chomp
      puts "Here are the students beginning with: #{input[0].upcase}"
      @students.each_with_object(names = []) do |student, arr|
        if student[:name][0].downcase == input[0].downcase
          puts "#{student[:name]} (#{student[:cohort]} cohort)"
          arr << student[:name] # storing the names here so can check if there were any, for the following puts line
        end
      end
      puts "Sorry, no students have names beginning with that character." if names.empty?
      break
 
    else
      puts "That's not a valid choice."
    end
  end
end

def print_footer
  if @students.empty?
    puts "No students are enrolled."
  elsif @students.length == 1
    puts "In total, we have #{@students.length} great student."
  else
    puts "In total, we have #{@students.length} great students."
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  puts
  puts "What would you like to do?"
  puts "1. Input students"
  puts "2. Show the students"
  puts "3. Save the student list"
  puts "4. Load saved students list"
  puts "10. Exit"
end

def process(selection)
  case selection
  when "1"
    puts "You have chosen to enter students."
    input_students
  when "2"
    puts "You have chosen to view the current students."
    show_students
  when "3"
    puts "You have chosen to save the current students to file."
    save_students
  when "4"
    puts "You have chosen to load a saved students file."
    load_students
  when "10"
    puts "See you next time!"
    exit
  else
    puts "Not a valid choice! Please choose again."
  end
end

def show_students
  print_header
  print_student_names
  print_footer
end

def save_students
  while true
    puts "What would you like to name the file?"
    filename = STDIN.gets.chomp
    filename += ".csv" if filename.split(".").length == 1 # In case the user doesn't provide a file type, add .csv ending
      if filename.split(".")[1] == "csv" # if the file ending is csv, continue to save
        CSV.open(filename, "w") do |csv| # saving to file
          @students.each do |student|
            csv << [student[:name], student[:cohort]]            
          end
        end
        puts "Students saved to file."
        break
      else # ask for input again if they gave a filename like "students.txt" or something with the wrong ending
        puts "Files will be stored in .csv format. Please enter a new filename with or without '.csv'."
      end
  end
end

def load_students(filename = "students.csv")
  while true
    puts "These are the available student data files:" # Lists all csv files in the directory
    possible_files = Dir.entries(".").select { |file| file.include?(".csv") }
    possible_files.each_with_index { |file, i| puts "#{i + 1}. #{file}" }
    puts "Which file would you like? Choose with number please."
    filenumber_choice = STDIN.gets.chomp.to_i

    if (1..possible_files.length).include?(filenumber_choice) # Checking they chose a possible option from the list of files
      CSV.foreach(possible_files[filenumber_choice - 1]) do |line| # reading in file
        student_name, cohort = line
        create_student(student_name, cohort.to_sym)
      end           
      puts "Student file has been loaded."
      break
    else
      puts "Please choose one of the listed files, by number."
    end
  end
end

def try_load_students
  filename = ARGV.first # This will be present if a filename was given as argument when this directory file was run
  # return if filename.nil?
  if !filename.nil? && File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.length} students from #{filename}."
  elsif !filename.nil? && !File.exists?(filename)
    puts "Sorry, #{filename} doesn't exist."
    exit
  elsif filename.nil? && !Dir.entries(".").select { |file| file.include?(".csv") }.empty? # Choosing an existing file if no argument was given
    while true
      puts "Do you want to load in an existing .csv file? Yes or no."
      choice = STDIN.gets.chomp.downcase
      if choice == "y" || choice == "yes"
        load_students
        puts "Loaded #{@students.length} students from 'students.csv'."
        break
      elsif choice == "n" || choice == "no"
        break
      else
        puts "That's not a valid choice."
      end
    end
  end
end


try_load_students
puts "Welcome to the Villains Academy Student Management Portal".center(100)
puts "-------------".center(100)
interactive_menu
