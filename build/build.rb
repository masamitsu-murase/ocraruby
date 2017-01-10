# -*- coding: utf-8 -*-

require("ruby_installer_manager")
require("pathname")
require("fileutils")
require_relative("ocra_builder")

BASE_DIR = Pathname(__dir__).parent + "tmp"

class OcraBuilderLite < OcraBuilderFixedStub
  EXE_NAME = "ocrarubylite.exe"

  def build
    build_binary(EXE_NAME, nil, "", "lite")
  end
end

class OcraBuilderNormal < OcraBuilderFixedStub
  EXE_NAME = "ocraruby.exe"
  LIBRARIES = %w(date time delegate forwardable observer singleton pp fileutils find pathname tempfile tmpdir csv json psych rexml/document yaml zlib digest erb stringio thread thwait win32ole base64 logger)

  def pre_build
    LIBRARIES.each do |lib|
      add_lib(lib)
    end

    super
  end

  def build
    build_binary(EXE_NAME, nil, "", "normal")
  end
end

class OcraBuilderFull < OcraBuilderFixedStub
  EXE_NAME = "ocrarubyfull.exe"

  def build
    dlls = Dir.glob(File.join(@ruby_dir, "bin", "*.dll")).to_a
      .map{ |i| File.basename(i) }.select{ |i| !(i.start_with?("msvcrt")) }

    build_binary(EXE_NAME, dlls, "--add-all-core", "full")
  end
end


[ OcraBuilderLite, OcraBuilderNormal, OcraBuilderFull ].each do |klass|
  ob = klass.new("ruby2.3.3", BASE_DIR)
  ob.prepare
  ob.build
end

