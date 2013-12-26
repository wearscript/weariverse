require 'fileutils'
require 'erb'
require 'open-uri'
class Compiler
  DEFAULT_SCRIPT = "<script>function s() {WS.say('Connected')};window.onload=function () {WS.serverConnect('{{WSUrl}}', 's')}</script>"

  def self.do path, nice_name, trigger
    if path.include? 'http'
      new_script = open(path) {|f| f.read}
    else
      new_script = File.read(path)
    end
    new_script.gsub! "\n", ""
    new_script.gsub! "\"", "\\\""

    $package = nice_name.gsub(/[-\s]/,"_").downcase
    $name = nice_name
    $trigger = trigger

    manifest_template = File.read('lib/templates/AndroidManifest.xml.erb')
    trigger_template = File.read('lib/templates/voice_trigger_start.xml.erb')
    strings_template = File.read('lib/templates/strings.xml.erb')

    build_id = Time.now.to_i.to_s
    build_path = "compiler/" + $package
    FileUtils.mkdir_p "compiler"
    FileUtils.rm_rf(build_path)
    FileUtils.cp_r("../wearscript/glass", build_path)
    FileUtils.cd build_path do
      FileUtils.cd("WearScript/src/main") do
        manifest = ERB.new(manifest_template, 0, "%<>").result
        File.write("AndroidManifest.xml", manifest)

        FileUtils.cd("java") do
          FileUtils.mkpath("com/weariverse")
          system("mv com/dappervision/wearscript com/weariverse/#{$package}")

          Dir.glob(File.join("**", "*.java")) do |name|
            text = File.read(name)
            text.gsub!("com.dappervision.wearscript", "com.weariverse.#{$package}")
            File.write name, text
          end

          FileUtils.cd("com/weariverse/#{$package}") do
            service = File.read('BackgroundService.java')
            service.gsub! DEFAULT_SCRIPT, new_script
            File.write("BackgroundService.java", service)
          end
        end
        FileUtils.cd("res") do
          trigger = ERB.new(trigger_template, 0, "%<>").result
          File.write("xml/voice_trigger_start.xml", trigger)
          strings = ERB.new(strings_template, 0, "%<>").result
          File.write("values/strings.xml", strings)
        end
      end
      raise "Build failed" unless system "./gradlew build"
      FileUtils.mv("WearScript/build/apk/WearScript-debug-unaligned.apk", "../#{$package}-#{build_id}.apk")
    end
    return "compiler/#{$package}-#{build_id}.apk"
  end
end
