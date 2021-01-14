class CreateStudent

  def initialize
    # A hash of months and their abbreviations. The values are arrays so that September could be abbreviated to Sep or Sept, because Sep seems weird
    @months = { January: ["Jan"], February: ["Feb"], March: ["Mar"], April: ["Apr"],
              May: ["May"], June: ["Jun"], July: ["Jul"], August: ["Aug"],
              September: ["Sept", "Sep"], October: ["Oct"], November: ["Nov"], December: ["Dec"] }
  end

  def input_students(students)
    puts "Please enter the names of the students.\nYou can optionally specify the cohort if it's not the current month - separate the cohort from the name with a comma. Full or abbreviated month names are both fine."
    puts "To finish, just hit return twice"
    full_input = STDIN.gets.delete!("\n")
    while !full_input.empty? do
      students << process_info_input(full_input)
      print_student_numbers(students)
      full_input = STDIN.gets.chomp
    end
    students
  end

  def process_info_input(full_input)
    full_name, cohort = full_input.split(", ").map(&:capitalize!) # this will capitalise both month and name. Annoying to anyone who deliberately uses a lower case name
    if cohort != nil && @months.include?(cohort.to_sym) # Checking for month full name in hash keys
      create_student(full_name, cohort.to_sym)
    elsif cohort != nil && @months.any? { |k, v| v.include?(cohort) } # Checking for month abbreviated name in hash values
      unabbreviated_month = @months.find { |k, v| v.include?(cohort) }
      create_student(full_name, unabbreviated_month[0])
    else 
      create_student(full_name) # If a month isn't provided, the default cohort is used
    end
  end

  def create_student(full_name, cohort = Time.now.strftime("%B").to_sym) # Default cohort is the current month
    {name: full_name, cohort: cohort}
  end

  def print_student_numbers(students)
    puts students.length == 1 ? "Now we have #{students.length} student." : "Now we have #{students.length} students."
  end

end
