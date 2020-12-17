# Write a short program that reads its own source code (search StackOverflow to find out how to get the name of the currently executed file) and prints it on the screen.
puts __FILE__
puts IO.readlines(__FILE__)