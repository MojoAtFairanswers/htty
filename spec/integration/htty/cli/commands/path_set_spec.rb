require 'spec_helper'
require File.expand_path("#{File.dirname __FILE__}/../../../../../lib/htty/session")
require File.expand_path("#{File.dirname __FILE__}/../../../../../lib/htty/cli/commands/path_set")

describe HTTY::CLI::Commands::PathSet do
  let :klass do
    subject.class
  end

  let :session do
    HTTY::Session.new nil
  end

  def instance(*arguments)
    klass.new :session => session, :arguments => arguments
  end

  describe 'without an argument' do
    it 'should raise an error' do
      expect{instance.perform}.to raise_error(ArgumentError)
    end
  end

  describe 'with an argument' do
    it 'should set path' do
      instance('foo').perform
      session.requests.last.uri.path.should == '/foo'
    end

    describe "where there is a non-Basic 'Authorization' header" do
      before :each do
        session.requests.last.header_set(*header)
        session.requests.last.headers.should include(header)
      end

      let(:header) { %w(Authorization foo) }

      it 'should not affect the header' do
        instance('bar').perform
        session.requests.last.headers.should include(header)
      end
    end
  end
end
