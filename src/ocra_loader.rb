# coding: utf-8

OCRARUBY_LOADER_OPTION = ARGV.shift
OCRARUBY_NAME = "ocraruby"
OCRARUBY_VERSION = "1.2"

if (defined?(Ocra))
  case(OCRARUBY_LOADER_OPTION)
  when "lite"
    # nothing to do
  when "normal"
    load("ocra_loader_libs.rb")
  when "full"
    # nothing to do
  else
    raise "Unknown option '#{OCRARUBY_LOADER_OPTION}'"
  end
  exit
end

#----------------------------------------------------------------
module Ocraruby
  class << self
    def usage
      exe_name = File.basename(ENV["OCRA_EXECUTABLE"])
      puts "Usage: #{exe_name} [-v|-h] [programfile] [arguments]"
    end

    def process_options(option)
      case(option)
      when "-v", "--version"
        puts "#{OCRARUBY_NAME} (#{OCRARUBY_LOADER_OPTION}) #{OCRARUBY_VERSION} - #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
        return true
      when "-h", "--help"
        usage
        return true
      else
        return false
      end
    end

    def reset_environment(filename)
      $0 = filename
      ARGV.shift
    end
  end
end

#----------------------------------------------------------------
if (ARGV.empty?)
  Ocraruby.usage
  exit
elsif (Ocraruby.process_options(ARGV[0]))
  exit
end

filename = File.expand_path(ARGV[0])
Ocraruby.reset_environment(filename)
load(filename)
