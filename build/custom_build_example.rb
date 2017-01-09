# -*- coding: utf-8 -*-

require("ruby_installer_manager")
require("pathname")
require("fileutils")
require_relative("ocra_builder")

BASE_DIR = Pathname(__dir__).parent + "tmp"

class Example < OcraBuilderStaticStub
  def build
    build_binary("ocraruby.exe", nil, "", "normal")
  end
end

ob = Example.new("ruby2.3.3", BASE_DIR)
ob.prepare
# [ "seven_zip_ruby" ].each do |gem|
[ ].each do |gem|
  ob.add_gem(gem)
end
ob.build

