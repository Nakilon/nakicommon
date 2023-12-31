module NakiCommon
  refine Array do
    Error = Class.new RuntimeError
    def assert_one
      raise Error, "size: #{size.to_s}" unless 1 == size
      at 0
    end
    def median
      (sort[size / 2] + sort[(size - 1) / 2]) / 2r
    end
    def mean
      reduce(:+)&.fdiv size
    end
  end
  def self.shorter_backtrace
    begin
      yield
    rescue
      $!.set_backtrace( $!.backtrace_locations.chunk(&:path).map do |path, locs|
        [path, locs.map(&:lineno).chunk(&:itself).map(&:first)].join ":"
      end )
      raise
    end
  end
  ENV.define_singleton_method :nakifetch do |key|
    ::ENV[key] || fail("no #{key} env var")
  end
  def self.ratelimit seconds, filename
    require "fileutils"
    while 0 < t = ::File.mtime("#{filename}.touch") - ::Time.now + seconds
      ::STDERR::puts "sleeping #{t} seconds (lock file: ./#{filename}.touch)"
      sleep t
    end if ::File.exist? "#{filename}.touch"
    ::FileUtils.touch "#{filename}.touch"
    yield
  end
end
