require 'rails/generators'

class MockGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  def create_mock_file
    path = "app/mocks/#{file_name}_mock.rb"
    if FileTest.exists?path
      raise FileExistError, "This filename ist used by another mock:#{path}"
    end

    copy_file "mock_template.rb", path
    gsub_file path, '-MockName-' , "#{class_name}"
  end

end

class FileExistError < StandardError; end