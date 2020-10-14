require 'benchmark'

desc 'Import data from json file to DB: rake reload_json[fixtures/small.json]'
task :reload_json, [:file_name] => :environment do |_task, args|
  puts "Import data from file #{args.file_name}..."
  DbImporter.new.call(source: args.file_name)
  puts "Done!"
end

desc 'Benchmark :reload_json task: rake reload_json_benchmark[fixtures/small.json]'
task :reload_json_benchmark, [:file_name] => :environment do |_task, args|
  bm = Benchmark.measure { Rake::Task['reload_json'].invoke(*args) }
  puts bm
end 
