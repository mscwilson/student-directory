require "csv"

class FileManager

  def save_students(students)
    while true
      puts "What would you like to name the file?"
      filename = STDIN.gets.chomp
      filename += ".csv" if filename.split(".").length == 1 # In case the user doesn't provide a file type, add .csv ending
        if filename.split(".")[1] == "csv" # if the file ending is csv, continue to save
          CSV.open(filename, "w") do |csv| # saving to file
            students.each do |student|
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

  def load_students(students, filename = "students.csv")
    while true
      puts "These are the available student data files:" # Lists all csv files in the directory
      possible_files = Dir.entries(".").select { |file| file.include?(".csv") }
      possible_files.each_with_index { |file, i| puts "#{i + 1}. #{file}" }
      puts "Which file would you like? Choose with number please."

      # NB currently no way to back out of choice at this point
      filenumber_choice = STDIN.gets.chomp.to_i

      if (1..possible_files.length).include?(filenumber_choice) # Checking they chose a possible option from the list of files
        CSV.foreach(possible_files[filenumber_choice - 1]) do |line| # reading in file
          student_name, cohort = line
          students << CreateStudent.new.create_student(student_name, cohort.to_sym)
        end           
        puts "Student file has been loaded."
        break
      else
        puts "Please choose one of the listed files, by number."
      end
    end
  end

  def try_load_students(students)
    filename = ARGV.first # This will be present if a filename was given as argument when this directory file was run
    # return if filename.nil?
    if !filename.nil? && File.exists?(filename)
      load_students(filename)
      puts "Loaded #{students.length} students from #{filename}."
    elsif !filename.nil? && !File.exists?(filename)
      puts "Sorry, #{filename} doesn't exist."
      exit
    elsif filename.nil? && !Dir.entries(".").select { |file| file.include?(".csv") }.empty? # Choosing an existing file if no argument was given
      while true
        puts "Do you want to load in an existing .csv file? Yes or no."
        choice = STDIN.gets.chomp.downcase
        if choice == "y" || choice == "yes"
          load_students(students)
          puts "Loaded #{students.length} students from 'students.csv'."
          break
        elsif choice == "n" || choice == "no"
          break
        else
          puts "That's not a valid choice."
        end
      end
    end
  end

end
