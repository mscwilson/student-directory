

# Currently not using any of the other default student info aside from cohort
def create_student(full_name, cohort = Time.now.strftime("%B").to_sym, height_cm = 165, country_of_origin = "UK", hobbies = ["coding"], no_of_pets = 0)
  {name: full_name,
  cohort: cohort,
  height_cm: height_cm,
  country_of_origin: country_of_origin,
  hobbies: hobbies,
  no_of_pets: no_of_pets}
end

def input_students
  puts "Please enter the names of the students.\nYou can optionally specify the cohort if it's not the current month - separate the cohort from the name with a comma. Full or abbreviated month names are both fine."
  puts "To finish, just hit return twice"
  students = []
  full_input = gets.delete!("\n")

# A hash of months and their abbreviations. The values are arrays so that September could be abbreviated to Sep or Sept, because Sep seems weird to me
  months = {January: ["Jan"], February: ["Feb"], March: ["Mar"], April: ["Apr"], May: ["May"], June: ["Jun"], July: ["Jul"],
            August: ["Aug"], September: ["Sept", "Sep"], October: ["Oct"], November: ["Nov"], December: ["Dec"]}
  
  while !full_input.empty? do
    full_name, cohort = full_input.split(", ")
    if cohort != nil && months.include?(cohort.capitalize.to_sym)
      students << create_student(full_name, cohort.capitalize)
    elsif cohort != nil && months.any? { |k, v| v.include?(cohort.capitalize) }
      unabbreviated_month = months.find { |k, v| v.include?(cohort.capitalize)}
      students << create_student(full_name, unabbreviated_month[0])
    else
      students << create_student(full_name)
    end

    if students.length == 1
      puts "Now we have #{students.length} student"
    else
      puts "Now we have #{students.length} students"
    end
    full_input = gets.chomp
  end
  students
end

def print_header
  puts "The students of Villains Academy".center(100)
  puts "-------------".center(100)
end

def print_names(students)
  puts "Print out all names or a subset? You can print by cohort, or all names starting with a certain letter, or all names shorter than a particular number."
  puts "Choose 'all', 'cohort', or type a letter or a number"
  input = gets.delete!("\n")
  if input == "all"
    counter = 0
    until counter == students.length
      print "#{counter + 1}.".center(4)
      puts "#{students[counter][:name]} (#{students[counter][:cohort]} cohort)"
      counter += 1
    end

  elsif input == "cohort"
    students.each_with_object(cohorts_list = []) { |dict, arr| arr << dict[:cohort]}
    cohorts_list.uniq!.each do |month|
      puts "#{month} cohort:"
      students.each { |student| puts "- #{student[:name]}" if student[:cohort] == month }
      puts
    end

  elsif input.to_i.is_a?(Integer) && input.to_i != 0
    students.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)" if student[:name].length < input.to_i }
  elsif input.is_a?(String) && input.length == 1
    students.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)" if student[:name][0].downcase == input.downcase }
  end
end

def print_footer(students)
  if students.length == 1
    puts "In total, we have #{students.length} great student."
  else
    puts "In total, we have #{students.length} great students."
  end
end

students = input_students
print_header
print_names(students)
print_footer(students)
