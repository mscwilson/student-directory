students = ["Dr Hannibal Lecter",
  "Darth Vader",
  "Nurse Ratched",
  "Michael Corleone",
  "Alex DeLarge",
  "The Wicked Witch of the West",
  "Terminator",
  "Freddy Kruegor",
  "The Joker",
  "Joffery Baratheon",
  "Norman Bates"]

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_names(students)
  students.each { |student| puts student}
end

def print_footer(students)
  puts "Overall, we have #{students.length} great students."
end

print_header
print_names(students)
print_footer(students)
