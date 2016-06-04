
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'amaze'

def fixture *part
  File.join(File.dirname(__FILE__), 'fixture',  *part)
end

def read_fixture *part
  File.read(fixture *part)
end

require 'rainbow'
Rainbow.enabled = false
