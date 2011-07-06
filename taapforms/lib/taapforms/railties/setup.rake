
namespace :taapforms do
  unless Rake::Task.task_defined?("taapforms:install")
    desc 'Installs javascript and creates directory structure to install taapforms'
    task :install do
      puts Taapforms::Engine.root
      src_directory = "#{Taapforms::Engine.root}/schemaobjects"
      dest_directory = "#{Rails.root}/schemaobjects"
      unless dest_dir.exist? directory
        dest_dir.mkdir directory
        
      end
    end
  end
end
