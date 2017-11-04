require "test_helper"

class LaCarte::Configuration::LoadSourcePathTest < LaCarte::TestCase
  def teardown
    super
    @instance = nil
  end

  def test_load_paths_immutable
    instance.add_source_path :file, datas_dir.join('correct.yml')

    instance.load_paths(:file) <<  '/root'

    assert_equal datas_dir.join('correct.yml').to_s, instance.load_paths(:file)
  end

  def test_add_source_path_to_include_a_source_path
    instance.add_source_path :file, datas_dir.join('correct.yml')

    assert_equal datas_dir.join('correct.yml').to_s, instance.load_paths(:file)
  end

  def test_raises_an_exception_when_adding_a_duplicate_index
    instance.add_source_path :file, datas_dir.join('correct.yml')

    assert_raises LaCarte::DuplicitySourceException do
      instance.add_source_path 'file', datas_dir.join('correct.yml')
    end
  end

  def test_raises_an_exception_when_adding_a_duplicate_path
    instance.add_source_path :file, datas_dir.join('correct.yml')

    assert_raises LaCarte::DuplicityPathException do
      instance.add_source_path :other_file, datas_dir.join('correct.yml')
    end
  end

  def test_raises_an_exception_when_adding_a_path_within_unknow_file_type
    assert_raises LaCarte::UnknownFileTypeException do
      instance.add_source_path :file, datas_dir.join('invalid_type.txt')
    end
  end

  def test_raises_an_exception_when_adding_the_path_of_a_nonexists_file
    assert_raises LaCarte::NonexistFileException do
      instance.add_source_path :file, datas_dir.join('nonexistent_file.rb')
    end
  end

  private

  def instance
    @instance ||= LaCarte::Configuration.send(:new)
  end
end
