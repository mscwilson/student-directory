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

# Printing out the list of students
puts "The students of Villains Academy"
puts "-------------"
students.each { |student| puts student}

# Now a summary of total number of students
puts "Overall, we have #{students.length} great students."
