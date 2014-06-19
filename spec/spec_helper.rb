require 'idobata/hooks'

require 'rspec/its'
require 'rack'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/hash/conversions'
require 'linguist'
require 'tapp'
require 'pry'

Dir[Idobata::Hook.root.join('../spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include HookHelper, type: :hook
end

Idobata::Hook.load!
