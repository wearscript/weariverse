REPO_NAME="openshades/wearscript-contrib"
task :default => [:build]

task :build do
  data = get_json 'metadata/categories.json'
  apps = {"categories" => {}}
  data["categories"].each do |cat|
    apps["categories"][cat] = get_category cat
  end
  File.open('_data/apps.yml', 'w') { |file| file.write(apps.to_yaml) }
end


def get_category name
  data = get_json "metadata/categories/#{name}.json"
  apps = {}
  data[name].each do |a|
    apps[a] = get_app a
  end
  return apps
end

def get_app name
  data = get_json "scripts/#{name}/manifest.json"
  data['url'] = "https://raw.github.com/#{REPO_NAME}/master/scripts/#{name}"
  return data
end

def get_json path
  require 'json'
  require 'net/http'
  uri = URI("https://raw.github.com/#{REPO_NAME}/master/#{path}")
  contents = Net::HTTP.get(uri)
  return JSON.parse(contents)
end
