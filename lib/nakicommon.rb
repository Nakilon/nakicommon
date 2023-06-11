module NakiCommon
  refine Array do
    Error = Class.new RuntimeError
    def assert_one
      raise Error, "size: #{size.to_s}" unless 1 == size
      at 0
    end
  end
end
