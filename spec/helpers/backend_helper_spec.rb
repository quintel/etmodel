require 'spec_helper'

describe BackendHelper do
  include BackendHelper

class Foo
  def bar
    puts 'hello world'
    if true
      puts 'test'
    end
  end; #bar

  # comment
  def foo
    puts 'hello world'
  end
end

  context "method Foo#bar" do
    subject { method_source(Foo.instance_method(:bar))}

    specify { should_not include("# comment")}
    specify { should include("def bar")}
    specify { should include("puts 'hello world'")}
    specify { should include("end; #bar")}
  end

end
