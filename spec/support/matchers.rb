require 'rails/dom/testing/assertions'

helper = Module.new {
  extend Rails::Dom::Testing::Assertions::DomAssertions

  def self.dom_equal?(expected, actual)
    expected_dom, actual_dom = fragment(expected), fragment(actual)

    compare_doms(expected_dom, actual_dom)
  end
}

RSpec::Matchers.define :be_dom_equal do |expected|
  match do |actual|
    a, e = [actual, expected].map {|str|
      str.gsub(/\s{2,}|\n/i, '')
    }

    helper.dom_equal?(e, a)
  end
end
