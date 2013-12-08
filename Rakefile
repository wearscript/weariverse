require 'fog'
require 'fileutils'
require 'json'
require 'yaml'
require_relative 'lib/script_builder'
WS_REPO_NAME="OpenShades/weariverse"
S3_BUCKET="weariverse-scripts"
task :default => [:apps, :sync]

desc "Build apps yml"
task :apps do
  Dir.chdir('scripts')
  ids = Dir.glob('*')
  Dir.chdir('..')
  apps = {}
  ids.each do |id|
    apps[id] = get_app(id)
  end
  File.open('scripts.yml', 'w') {|f| f.write(apps.to_yaml)}
  puts "Updated metadata YML"
end

def get_app name
  data = get_json "scripts/#{name}/manifest.json"
  data['app_uri'] = "https://s3.amazonaws.com/#{S3_BUCKET}/#{name}"
  data['source_uri'] = "https://github.com/#{WS_REPO_NAME}/tree/master/scripts/#{name}"
  data['features'] = []
  data['tags'].each do |t|
    if ScriptBuilder.FEATURES.include? t
      data['features'] << t
    end
  end
  return data
end

def get_json path
  contents =  File.open(path).read
  return JSON.parse(contents)
end

desc "Sync assets to S3"
task :sync do
  storage = Fog::Storage.new(provider: 'AWS', aws_access_key_id: ENV['AWS_ID'], aws_secret_access_key: ENV['AWS_SECRET'])
  directory = storage.directories.get(S3_BUCKET)

  unless directory
    directory = storage.directories.create(
        key: S3_BUCKET, # globally unique name
        public: true
    )
  end

  Dir.chdir('scripts')
  ids = Dir.glob('*')
  Dir.chdir('..')
  ids.each do |id|
    path = "scripts/#{id}/index.html"
    key = "#{id}/index.html"
    needs_update = true
    if file = directory.files.head(key)
      needs_update = !(file.content_length == File.size(path))
    end

    if needs_update
      puts "Uploading #{id}..."
      file = directory.files.new(key: key)
      file.storage_class = 'REDUCED_REDUNDANCY'
      file.public = true
      file.body = File.open(path)
      file.save
    else
      puts "Skipping #{id}"
    end
  end
end

desc "Make a new script"
task :new do
  ScriptBuilder.do
end

task :submit do
  puts "What is the script name?"
  name = $stdin.gets.chomp
  ScriptBuilder.new(name).submit
end
