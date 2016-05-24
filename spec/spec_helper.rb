
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'amaze'

def read_fixture(*part)
  file = File.join(File.dirname(__FILE__), 'fixture',  *part)
  File.read file
end
