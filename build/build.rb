
require("ruby_installer_manager")
require("pathname")

BASE_DIR = Pathname(__dir__).parent + "tmp"
SRC_DIR = Pathname(__dir__).parent + "src"

am = RubyInstallerManager::AutoManager.create
p am.ruby_list


ruby_name_list = [ "ruby2.3.3" ]

ruby_list = ruby_name_list.map do |ruby_name|
  next am.ruby_manager(ruby_name, BASE_DIR + ruby_name, BASE_DIR + "#{ruby_name}.7z")
end

devkit_name_list = ruby_name_list.map{ |i| am.devkit_name_for_ruby(i) }.uniq
devkit_list = devkit_name_list.map do |devkit_name|
  next am.devkit_manager(devkit_name, BASE_DIR + devkit_name, BASE_DIR + "#{devkit_name}.7z")
end


#================================================================
# Prepare and install
if false
ruby_list.zip(ruby_name_list) do |ruby, ruby_name|
  puts ruby_name
  ruby.prepare
end

devkit_list.zip(devkit_name_list) do |devkit, devkit_name|
  puts devkit_name
  devkit.prepare
end

devkit_list.zip(devkit_name_list) do |devkit, devkit_name|
  devkit.install(ruby_list.zip(ruby_name_list).select{ |i,j| am.devkit_name_for_ruby(j) == devkit_name }.map(&:first))
end
end


#================================================================
# Install gems
gem_list = [ "ocra", "seven_zip_ruby" ]
ruby_list.each do |ruby|
#  ruby.update_rubygems
#  gem_list.each do |gem|
#    ruby.install_gem(gem)
#  end
  ruby.ruby_env do
    Dir.chdir(SRC_DIR) do
      system("ocra ocra_loader.rb -- normal")
    end
  end
end


