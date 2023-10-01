# frozen_string_literal: true

require 'yaml'

# YAML to TSV
input_file = ARGV[0]
output_file = ARGV[1]

# Error catch
def input_format_error
  puts 'Error: Your input format needs to be like:'
  puts ' - ruby yml_to_tsv.rb input_file.yml output_file.tsv'
  exit(1)
end

def file_not_found_error(file)
  puts "Error: File not found - #{file}"
  exit(1)
end

def invalid_yaml_format_error
  puts 'Error: Invalid YAML format. Expected an array of hashes.'
  exit(1)
end

def output_file_exists_error(output_file)
  puts "Error: Output file already exists - #{output_file}. Choose a different name."
  exit(1)
end

input_format_error if ARGV.length != 2
file_not_found_error(input_file) unless File.exist?(input_file)

def convert_yaml_to_tsv(input_file, output_file)
  data = load_yaml_file(input_file)
  save_as_tsv(data, output_file)
end

def load_yaml_file(file)
  data = YAML.load_file(file)
  invalid_yaml_format_error unless data.is_a?(Array) && data.all? { |item| item.is_a?(Hash) }
  data
end

def write_tsv_file(output_file, headers, data)
  File.open(output_file, 'w') do |file|
    file.puts headers.join("\t")
    data.each { |row| file.puts headers.map { |header| row[header] }.join("\t") }
  end
end

def save_as_tsv(data, output_file)
  if File.exist?(output_file)
    output_file_exists_error(output_file)
  else
    headers = data.first.keys
    write_tsv_file(output_file, headers, data)
    puts "Data has been converted and saved to #{output_file}"
  end
end

convert_yaml_to_tsv(input_file, output_file)
