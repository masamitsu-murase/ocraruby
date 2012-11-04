# ocraruby - single executable Ruby binary packaged by OCRA

## Description

This is a single Windows executable Ruby binary packaged by [OCRA](https://github.com/larsch/ocra).  
Please download executable binaries from [Download Page](https://github.com/masamitsu-murase/ocraruby/downloads).

* **ocraruby.exe**  
  This includes frequently used (and my favorite) standard libraries except for network libraries.  
  Please refer to `src/ocra_loader_libs.rb` to find included libraries.

* **ocrarubyfull.exe**  
  This includes all standard libraries.

* **ocrarubylite.exe**  
  This includes no standard libraries.

Any gem libraries are not included.

## Usage

You can use ocraruby.exe just like standard ruby command.  
`__FILE__`, `$0` and `ARGV` can be referred in your script.

```ruby
# sample.rb
require("pathname")

ARGV.each do |arg|
  puts arg
end

if ($0 == __FILE__)
  puts __FILE__
end
```

You can run this script as follows:
```console
> ocraruby.exe sample.rb 1 2
1
2
sample.rb
```

## Credits

Ocraruby executable binary is built with [RubyInstaller](http://rubyinstaller.org/) and [OCRA](https://github.com/larsch/ocra).  

RubyInstaller is a Ruby execution environment on Windows.  
Thank you, RubyInstaller Team.

OCRA is a great library to build Windows executable binary from Ruby script.  
Thank you, Lars Christensen, OCRA author.  

Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.  
Thank you, Matz and Ruby developer team.

## License

Ocraruby is distributed under the MIT License.
Please refer to License.txt.
