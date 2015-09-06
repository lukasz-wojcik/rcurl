require 'minitest/autorun'
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new


# Extend Kernel in order to assign
# results of puts into variable

module Kernel

  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out
  ensure
    $stdout = STDOUT
  end

end
