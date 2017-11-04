require "test_helper"

module ProcessorPluginTest; end
module OtherProcessorPluginTest; end

class LaCarte::Configuration::BuildProcessorsTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_build_processors_immutable
    instance.build_processors << 'invalid value'
    assert_equal [], instance.build_processors
  end

  def test_add_builder_processor_to_include_a_module
    instance.add_builder_processor ProcessorPluginTest

    assert_includes instance.build_processors, ProcessorPluginTest
  end

  def test_add_builder_processor_to_include_a_module_name
    instance.add_builder_processor 'ProcessorPluginTest'

    assert_includes instance.build_processors, ProcessorPluginTest
  end

  def test_add_builder_processor_to_include_many_modules
    instance.add_builder_processor [ProcessorPluginTest, OtherProcessorPluginTest]

    assert_includes instance.build_processors, OtherProcessorPluginTest
    assert_includes instance.build_processors, ProcessorPluginTest
  end

  def test_raises_an_exception_when_adding_non_module_object
    c = Class.new

    assert_raises LaCarte::NoModuleException do
      instance.add_builder_processor c
    end

    assert_raises LaCarte::NoModuleException do
      instance.add_builder_processor c.new
    end
  end

  def test_raises_an_exception_when_adding_a_invalid_module_name
    assert_raises LaCarte::NoModuleException do
      instance.add_builder_processor 'InvalidModule'
    end
  end

  def test_raises_an_exception_when_adding_a_duplicate_module
    instance.add_builder_processor ProcessorPluginTest

    assert_raises LaCarte::DuplicityBuilderException do
        instance.add_builder_processor ProcessorPluginTest
    end
  end

  private

  def instance
    @instance ||= LaCarte::Configuration.send(:new)
  end
end
