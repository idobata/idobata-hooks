module Idobata::Hook
  class Error < StandardError; end
  class BadRequest < Error; end
  class UnsupportedContentType < Error; end
  class SkipProcessing < Error; end
end
