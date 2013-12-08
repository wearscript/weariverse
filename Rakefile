require 'fileutils'
require 'json'
require 'yaml'
WS_REPO_NAME="OpenShades/weariverse"
task :default => [:apps]

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
  data['app_uri'] = "https://raw.github.com/#{WS_REPO_NAME}/master/scripts/#{name}"
  data['source_uri'] = "https://github.com/#{WS_REPO_NAME}/tree/master/scripts/#{name}"
  data['features'] = []
  data['tags'].each do |t|
    if ['server', 'hardware', 'multiglass', 'widget', 'extra-apk', 'eyetracker', 'custom-web'].include? t
      data['features'] << t
    end
  end
  return data
end

def get_json path
  contents =  File.open(path).read
  return JSON.parse(contents)
end
