require 'middleman-gh-pages'
require 'json'
WS_REPO_NAME="openshades/wearscript-contrib"
task :default => [:apps, :publish]

task :apps do
  apps = all_categories
  File.open('data/shared.yml', 'w') {|f| f.write(apps.to_yaml)}
end

def all_categories
  data = get_json 'metadata/categories.json'
  categories = {}
  data["categories"].each do |cat|
    categories[cat] = get_category cat
  end
  categories
end

def get_category name
  cat = get_json "metadata/categories/#{name}.json"
  apps = {}
  cat[name].each do |v|
    apps[v] = get_app v
  end
  return apps
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
