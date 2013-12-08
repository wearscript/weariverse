require 'json'
require 'fileutils'
require 'shell'
require 'git'
class ScriptBuilder
  FEATURES = ['server', 'hardware', 'multiglass', 'widget', 'extra-apk', 'eyetracker', 'custom-web']
  def self.FEATURES
    FEATURES
  end
  def self.do
    puts "What is the name of your script?"
    puts "\tPlease use kabob case. (your-script-name)"
    name = $stdin.gets.chomp
    ScriptBuilder.new(name).do
  end

  def initialize name
    @manifest = {}
    @manifest[:name] = name
    @name = name
    @manifest[:authors] = []
    @manifest[:tags] = []
    @git = Git.open(Dir.pwd, log: Logger.new(STDOUT))
  end

  def do
    author
    begin
      puts "Would you like to add another author? [y/N]"
      another = $stdin.gets.chomp == 'y'
      author if another
    end while another
    puts "App description:"
    @manifest[:description] = $stdin.gets.chomp
    puts "\nNow we are going to ask what features you will require"
    FEATURES.each do |f|
      puts "Do you use #{f}? [y/N]"
      @manifest[:tags] << f if $stdin.gets.chomp == 'y'
    end
    puts "Enter tags, one each line. Blank line to finish"
    while (tag = $stdin.gets.chomp).length > 0
      @manifest[:tags] << tag
    end
    write
    git_new
  end

  def author
    puts "Author Information:"
    a = {}
    puts "Name:"
    a[:name] = $stdin.gets.chomp
    puts "Email:"
    a[:email] = $stdin.gets.chomp
    puts "Github:"
    a[:github] = $stdin.gets.chomp
    puts "URL:"
    a[:url] = $stdin.gets.chomp
    @manifest[:authors] << a
  end

  def write
    puts "Building your script skeleton"
    @path = "scripts/#{@name}"
    FileUtils.mkdir_p(@path)
    FileUtils.mkdir_p("#{@path}/includes")
    File.open("#{@path}/includes/.gitkeep", 'w') {|f| f.write('')}
    FileUtils.mkdir_p("#{@path}/screenshots")
    File.open("#{@path}/screenshots/.gitkeep", 'w') {|f| f.write('')}
    FileUtils.cp("template.html", "#{@path}/index.html")
    File.open("#{@path}/manifest.json", 'w') {|f| f.write(JSON.pretty_generate(@manifest))}
  end

  def git_new
    @git.add(@path)
    @git.remote('origin').fetch
    @git.rebase('origin/master')
  end

  def submit
    @git.add(@path)
    @git.remote('origin').fetch
    @git.rebase('origin/master')
  end
end
