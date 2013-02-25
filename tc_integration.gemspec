# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'bundler/version'
 
Gem::Specification.new do |s|
  s.name              = "tc_integration"  
  s.version           = "0.0.1"  # i.e. (major,non-backwards compatable).(backwards compatable).(bugfix)
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Nigel Thorne"] 
  s.email             = "github@nigelthorne.com" # optional
  s.summary           = "Test Complete integration." # optional
  s.homepage          = "http://www.github.com/nigelthorne/tc_integration"  # optional
  s.description       = "A simple layer ontop of TestComplete's COM layer." # optional

# s.executables = ['main.rb']  # i.e. 'vr' (optional, blank if library project)
# s.default_executable = ['main.rb']  # i.e. 'vr' (optional, blank if library project)
# s.bindir = ['.']    # optional, default = bin

  s.require_paths     = ['.']  # optional, default = lib 
  s.files             = Dir.glob("{bin,lib}/**/*") + %w(LICENSE.txt README.rdoc)
  s.rubyforge_project = "nowarning" # supress warning message 
  s.require_path      = 'lib'
end
