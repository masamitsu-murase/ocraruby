# -*- coding: utf-8 -*-

require("ruby_installer_manager")
require("pathname")
require("fileutils")

class OcraBuilderBase
  BIN_DIR = Pathname(__dir__).parent + "bin"
  SRC_DIR = Pathname(__dir__).parent + "src"
  ADDITIONAL_LIBRARIES = SRC_DIR + "additional_libraries.txt"
  SRC = SRC_DIR + "ocra_loader.rb"
  ICON = SRC_DIR + "ocraruby.ico"

  DEFAULT_DLL = [ "AutoItX3.dll", "ruby.exe.manifest" ]

  def initialize(ruby_name, dir)
    dir = Pathname(dir)

    @ruby_name = ruby_name
    @ruby_dir = dir + ruby_name

    @am =RubyInstallerManager::AutoManager.create
    @ruby = @am.ruby_manager(ruby_name, @ruby_dir, dir + "#{@ruby_dir}.7z")
    devkit_name = @am.devkit_name_for_ruby(ruby_name)
    @devkit = @am.devkit_manager(devkit_name, dir + devkit_name, dir + "#{devkit_name}.7z")

    @gems = []
    @libs = []
  end
  attr_reader :ruby_name, :ruby, :devkit

  def prepare
    @ruby.prepare
    @devkit.prepare
    @devkit.install(@ruby)

    @ruby.install_gem("ocra")
  end

  def add_lib(lib)
    @libs.push(lib)
  end

  def add_gem(gem, version: nil, local_file_path: nil, platform: nil)
    if local_file_path
      @ruby.install_gem(local_file_path, version: version, platform: platform)
    else
      @ruby.install_gem(gem, version: version, platform: platform)
    end
    @gems.push([ gem, version ])
  end

  def build_binary(exe_name, dlls, arg_ocra, arg_ocraruby)
    begin
      pre_build

      dlls = [] unless dlls
      dlls = (dlls + DEFAULT_DLL).uniq

      arg_ocra = Array(arg_ocra)
      arg_ocraruby = Array(arg_ocraruby)
      Dir.chdir(SRC_DIR) do
        cmd = "ocra #{SRC.basename}"
        cmd += dlls.map{ |i| " --dll #{i}" }.join("")
        cmd += " --output #{exe_name} --icon #{ICON.basename} #{arg_ocra.join(' ')} -- #{arg_ocraruby.join(' ')}"

        @ruby.ruby_env do
          system(cmd)
        end

        FileUtils.mv(exe_name, BIN_DIR)
      end
    ensure
      post_build
    end
  end

  def pre_build
    File.open(ADDITIONAL_LIBRARIES, "w") do |file|
      @gems.each do |gem|
        file.puts gem[0]
      end
      @libs.each do |lib|
        file.puts lib
      end
    end

    DEFAULT_DLL.each do |dll|
      FileUtils.cp(SRC_DIR + dll, @ruby.dir + "bin")
    end
  end

  def post_build
    DEFAULT_DLL.each do |dll|
      FileUtils.rm(@ruby.dir + "bin" + dll)
    end
  end
end

class OcraBuilderFixedStub < OcraBuilderBase
  EXE_NAME = "ocraruby.exe"

  def pre_build
    super

    dest_path = Dir.glob(File.join(@ruby_dir.to_s, "**", "ocra", "stub.exe")).first
    @original_stub_data = File.open(dest_path, "rb", &:read)
    FileUtils.cp(SRC_DIR + "stub_retry_dir_creation.exe", dest_path)
  end

  def build
    build_binary(EXE_NAME, nil, "", "normal")
  end

  def post_build
    dest_path = Dir.glob(File.join(@ruby_dir.to_s, "**", "ocra", "stub.exe")).first
    File.open(dest_path, "wb") do |file|
      file.write(@original_stub_data)
    end

    super
  end
end

class OcraBuilderStaticStub < OcraBuilderBase
  EXE_NAME = "ocraruby.exe"

  def pre_build
    super

    dest_path = Dir.glob(File.join(@ruby_dir.to_s, "**", "ocra", "stub.exe")).first
    @original_stub_data = File.open(dest_path, "rb", &:read)
    FileUtils.cp(SRC_DIR + "stub_static_dir.exe", dest_path)
  end

  def build
    build_binary(EXE_NAME, nil, "", "normal")
  end

  def post_build
    dest_path = Dir.glob(File.join(@ruby_dir.to_s, "**", "ocra", "stub.exe")).first
    File.open(dest_path, "wb") do |file|
      file.write(@original_stub_data)
    end

    super
  end
end
