module Nakicommon
  module Rake

    # @example
    #   task "task" do
    #     require "nakicommon/rake"
    #     extend Nakicommon::Rake
    #     puts sh_output cmd
    def sh_output cmd
      require "open3"
      output, status = ::Open3.capture2e cmd
      unless status.success?
        puts output
        fail "exitstatus: #{status.exitstatus}"
      end
      output
    end

  end
end
# require "rake/dsl_definition"
# ::Rake::DSL.include ::Nakicommon::Rake
