module NakiCommon
  Error = ::Class.new ::RuntimeError
  refine Array do
    def assert_one
      return at 0 if 1 == size
      yield self if block_given?
      raise Error, "size: #{size.to_s}"
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
  def self.ratelimit seconds, filename
    require "fileutils"
    while 0 < t = ::File.mtime("#{filename}.touch") - ::Time.now + seconds
      ::STDERR::puts "sleeping #{t} seconds (lock file: ./#{filename}.touch)"
      sleep t
    end if ::File.exist? "#{filename}.touch"
    ::FileUtils.touch "#{filename}.touch"
    yield
  end
  module Cache
    def self.nethttputils url, id, dir = "cache_nethttputils"
      require "base58"
      filename = "#{dir}/#{::Base58.binary_to_base58 id.to_s.force_encoding "BINARY"}"
      if ::File.exist? filename
        ::File.binread filename
      else
        require "fileutils"
        ::FileUtils.mkdir_p dir
        require "nethttputils"
        ::STDERR.puts "downloading #{url.to_s.inspect}"
        ::NetHTTPUtils.request_data(url).tap do |_|
          ::File.binwrite filename, _
        end
      end
    end
  end
end
