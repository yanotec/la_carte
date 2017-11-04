require 'test_helper'

class LaCarte::Configuration::RequireFieldsTest < LaCarte::TestCase
  def setup
    super
    instance.add_source_path :source, sources_dir.join('one_level.yml')
  end

  def teardown
    super
    @instance = nil
  end

  def test_the_additions_of_required_fields_for_reading_the_sources_files
    instance.add_required_fields :name, :url, to: :source

    assert_equal instance.required_fields(:source), [:name, :url]
  end

  def test_the_merge_fields_when_add_mutiple_times_to_a_source
    instance.add_required_fields :name, :url, to: :source
    instance.add_required_fields :id, to: :source

    assert_equal instance.required_fields(:source), [:name, :url, :id]
  end

  def test_raise_exception_when_source_does_not_exist
    assert_raises LaCarte::NoSourceException do
      instance.add_required_fields :id, to: :invalid_source
    end
  end

  def test_raise_exception_when_source_is_not_informed
    assert_raises LaCarte::NoSourceException do
      instance.add_required_fields :id
    end
  end

  def test_raise_exception_when_fields_are_not_informed
    assert_raises ArgumentError do
      instance.add_required_fields to: :source
    end
  end

  private

  def instance
    @instance ||= LaCarte::Configuration.send(:new)
  end
end
