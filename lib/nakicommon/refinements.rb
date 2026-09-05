module Nakicommon
  module RefinementArray
    AssertError = ::Class.new ::RuntimeError
    refine ::Array do
      def assert_one
        return at 0 if 1 == size
        raise AssertError, "size: #{size}"
      end
    end
  end
end

# test
using ::Nakicommon::RefinementArray
fail unless 1 == [1].assert_one
begin
  [].assert_one
rescue Nakicommon::RefinementArray::AssertError
else
  fail
end
