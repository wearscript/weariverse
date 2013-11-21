require 'middleman-gh-pages'
require 'fileutils'
require 'json'
require 'yaml'
WS_REPO_NAME="openshades/weariverse"
task :default => [:apps, :publish]

desc "Build apps yml"
task :apps do
  Dir.chdir('scripts')
  ids = Dir.glob('*')
  Dir.chdir('..')
  apps = {}
  ids.each do |id|
    apps[id] = get_app(id)
  end
  FileUtils.mkdir_p 'data'
  File.open('data/shared.yml', 'w') {|f| f.write(apps.to_yaml)}
  puts "Updated metadata YML"
end

def get_app name
  data = get_json "scripts/#{name}/manifest.json"
  data['app_uri'] = "https://raw.github.com/#{WS_REPO_NAME}/master/scripts/#{name}"
  return data
end

def get_json path
  contents =  File.open(path).read
  return JSON.parse(contents)
end
