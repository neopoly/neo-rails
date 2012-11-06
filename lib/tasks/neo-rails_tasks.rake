namespace :"neo-rails" do
  desc "standard tasks for a new application"
  task :setup do
    ["build:presenter", "build:mock"].each do |task|
      Rake::Task["neo-rails:#{task}"].invoke
    end
  end

  namespace :build do
    def copy_from_template(path)
      templates = File.expand_path("../share/", __FILE__)
      rails     = Rails.root.to_s
      sh "mkdir -p #{rails}/#{File.dirname path}"
      cp "#{templates}/#{path}", "#{rails}/#{path}"
    end

    desc "build application base presenter"
    task :presenter do
      copy_from_template "app/presenters/presenter.rb"
    end

    desc "build application base mock"
    task :mock do
      copy_from_template "app/mocks/mock.rb"
    end
  end
end
