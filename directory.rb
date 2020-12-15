def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"
  students = []
  name = gets.chomp
  while !name.empty? do
    students << {name: name, cohort: :november}
    puts "Now we have #{students.length} students"
    name = gets.chomp
  end
  students
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_names(students)
  puts "Print out all names or a subset? You can print all names starting with a certain letter, or all names shorter than a particular number."
  puts "Choose 'all', or type a letter, or a number"
  input = gets.chomp
  if input == "all"
    students.each_with_index { |student, i| puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort)"}
  elsif input.to_i.is_a?(Integer) && input.to_i != 0
    students.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)" if student[:name].length < input.to_i }
  elsif input.is_a?(String) && input.length == 1
    students.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)" if student[:name][0].downcase == input.downcase }
  end
end

def print_footer(students)
  puts "In total, we have #{students.length} great students."
end

students = input_students
print_header
print_names(students)
print_footer(students)
