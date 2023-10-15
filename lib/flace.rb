module NakiCommon
  class << self
    attr_accessor :print_require
  end
  # self.attr_accessor :print_require
  self.print_require = true
  def self.clear_env *exceptions
    ::ENV.keep_if{ |k,| exceptions.include? k }
    # ENV["PATH"] ||= ""
  end
  def self.flace lib
    puts "faking #{lib}"
    ::FileUtils.mkdir_p ::File.dirname "#{::Dir.tmpdir}/fake_lib/#{lib}"
    ::FileUtils.touch "#{::Dir.tmpdir}/fake_lib/#{lib}.rb"
    require lib
  end
end

require "pathname"
Kernel.class_eval do
  old = instance_method :require
  # https://github.com/Homebrew/legacy-homebrew/commit/586663d228f2bd31d67bc86042d0004b4f44e82d
  define_method :require do |lib|
    old.bind(self).(lib).tap do |_|
      next unless _
      next unless NakiCommon.print_require
      # puts "#{" " * caller.size}flace require #{lib.inspect} (#{::Pathname.new(::File.expand_path caller[0]).relative_path_from(::Pathname.new ::File.expand_path ::Dir.pwd)})"
      puts "#{" " * caller.size}flace require #{lib.inspect} (#{::File.basename caller[0]})"
      # puts "#{" " * caller.size}flace require #{lib.inspect}"
    end
  end
end

require "tmpdir"
FileUtils.rm_rf "#{Dir.tmpdir}/fake_lib"
FileUtils.mkdir_p "#{Dir.tmpdir}/fake_lib"
$LOAD_PATH.unshift "#{Dir.tmpdir}/fake_lib"
