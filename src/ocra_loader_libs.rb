# coding: utf-8

libs = %w(date time delegate forwardable observer singleton pp fileutils find
  pathname tempfile tmpdir csv json psych rexml/document yaml zlib
  digest erb stringio thread thwait win32ole base64 logger)

libs.each do |lib|
  require(lib)
end

