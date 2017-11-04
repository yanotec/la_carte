$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "la_carte"

require "minitest/autorun"

TEST_CASE = defined?(Minitest::Test) ? Minitest::Test : MiniTest::Unit::TestCase


class LaCarte::TestCase < TEST_CASE
  def setup
    super
    Thread.current[:la_carte_config] = nil
  end

  def teardown
    Thread.current[:la_carte_config] = nil
    super
  end

  private

  def assert_private_method(klass, method)
    assert_raises NoMethodError do
      klass.public_send(method)
    end
    assert_includes klass.private_methods, method
  end

  def config
    LaCarte.config
  end

  def load_paths
    config.load_paths
  end

  def datas_dir
    Pathname.new(File.dirname(__FILE__)).join('fixtures', 'datas')
  end
end
