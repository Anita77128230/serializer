# frozen_string_literal: true

require 'yaml'

# TSV to YAML
input_file = ARGV[0]
output_file = ARGV[1]

# Error catch
def input_format_error
  puts 'Error: Your input format need to be like: '
  puts ' - ruby tsv_to_yml.rb input_file.tsv output_file.yml'
  exit(1)
end

def file_not_found_error(file)
  puts "Error: File not found - #{file}"
  exit(1)
end

def output_file_exists_error(output_file)
  puts "Error: Output file already exists - #{output_file}. Choose a different name."
  exit(1)
end

input_format_error if ARGV.length != 2
file_not_found_error(input_file) unless File.exist?(input_file)

def convert_tsv_to_yaml(input_file, output_file)
  data = read_tsv_file(input_file)
  save_as_yaml(data, output_file)
end

def read_tsv_file(file)
  header, *lines = File.read(file).split("\n")
  header = header.chomp.split("\t")
  lines.map do |line|
    values = line.chomp.split("\t")
    header.zip(values).to_h
  end
end

def save_as_yaml(data, output_file)
  if File.exist?(output_file)
    output_file_exists_error(output_file)
  else
    File.write(output_file, data.to_yaml)
    puts "Data has been converted and saved to #{output_file}"
  end
end

convert_tsv_to_yaml(input_file, output_file)
