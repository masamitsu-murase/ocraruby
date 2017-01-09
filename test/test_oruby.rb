
require("pathname")
require("tempfile")
require("test/unit")


class OcrarubyTest < Test::Unit::TestCase
  RUBY_PATH = "ruby"
  BIN_PATH = Pathname(__dir__).parent + "bin"
  OCRARUBY_PATH = BIN_PATH + "ocraruby"

  TEMP_DIR = (Pathname(__dir__) + "tmp").expand_path
  TEMP_DIR.mkpath

  def save_tempfile(str)
    file = nil
    Tempfile.open([ "ocraruby_test", ".rb" ], TEMP_DIR) do |f|
      f.write(str)
      file = f
    end
    return file
  end

  def run_ruby(*args)
    cmd = [ RUBY_PATH, *args ].map{ |i| "\"#{i}\"" }.join(' ')
    return `#{cmd}`
  end

  def run_ocraruby(*args)
    cmd = [ OCRARUBY_PATH, *args ].map{ |i| "\"#{i}\"" }.join(' ')
    return `#{cmd}`
  end

  def run_both(*args)
    return [ run_ruby(*args), run_ocraruby(*args) ]
  end

  def test___FILE__
    str = <<'EOS'
puts __FILE__
EOS

    file = save_tempfile(str)
    rb, orb = run_both(file.path)

    assert_equal(rb, orb, "check __FILE__")
  end

  def test_0
    str = <<'EOS'
puts $0
EOS

    file = save_tempfile(str)
    rb, orb = run_both(file.path)

    assert_equal(rb, orb, "check $0")
  end

  def test_arguments
    str = <<'EOS'
ARGV.each do |i|
  p i
end
EOS

    file = save_tempfile(str)
    rb, orb = run_both(file.path, 1, "ab c")

    assert_equal(rb, orb, "check arguments")
  end

  def test_LOADED_FEATURES
    str = <<'EOS'
p $LOADED_FEATURES.map{ |i| File.basename(i) }
require("pathname")
p $LOADED_FEATURES.map{ |i| File.basename(i) }
EOS

    file = save_tempfile(str)
    rb, orb = run_both(file.path)

    assert_equal(rb, orb, "check LOADED_FEATURES")
  end
end

