# frozen_string_literal: true

require 'fileutils'

# Define the directory where the screenshots are located
# Replace 'screenshots_directory' with the path to your directory containing the screenshots
directory_path = File.expand_path('~/Desktop/Videos')
puts directory_path

# Get all the screenshot files in the directory (assuming .png or .jpg for this example)
screenshots = Dir.glob("#{directory_path}/*.{png,jpg,jpeg}")
puts screenshots.inspect

# Sort the screenshots based on the timestamps in their current filenames
# Assuming timestamps are part of the filenames
sorted_screenshots = screenshots.sort_by { |file| File.mtime(file) }

# Rename the files sequentially starting from 1
sorted_screenshots.each_with_index do |file, index|
  # Get the file extension (.png, .jpg, etc.)
  extension = File.extname(file)
  puts extension

  # Define the new filename, starting with number 1, without padding (e.g., 1.png, 2.png)
  new_filename = "#{directory_path}/#{index + 1}#{extension}"

  # Rename the file
  FileUtils.mv(file, new_filename)

  puts "Renamed #{File.basename(file)} to #{File.basename(new_filename)}"
end
