require "spec_helper"
require 'live_resource/resource'

include LiveResource::ActiveRecord

describe Dependency do

  let(:dependency) { Dependency.new(resource, model_class, proc, *events) }

  let(:resource) { double(LiveResource::Resource) }

  let(:model_class) do
    class User < ActiveRecord::Base
    end
    User
  end

  let(:events) { nil }
  let(:proc) { double(Proc) }

  ActiveRecord::Callbacks::CALLBACKS.each do |callback|
    context "##{callback}" do
      subject { dependency.send(callback.to_sym, record) }

      let(:record) { model_class.new }

      it "should call #invoke with the ActiveRecord instance and the callback name" do
        dependency.should_receive(:invoke).with(record, callback)
        subject
      end
    end
  end

  it "should pass the target to the superclass" do
    expect(dependency.target).to be model_class
  end

  it "should pass the resource to the superclass" do
    expect(dependency.resource).to be resource
  end

  describe ".accepts_target?" do
    subject { Dependency.accepts_target?(target) }

    context 'when the target is an ActiveRecord subclass' do
      let(:user_class) do
        class User < ActiveRecord::Base
        end
        User
      end

      let(:target) { user_class }

      it { should == true }
    end

    context 'when the target is not an ActiveRecord subclass' do
      let(:target) { Class.new }

      it { should == false }
    end
  end

  describe "#watch" do
    subject { dependency.watch }

    context 'when some events are supplied' do
      let(:events) { [:after_create, :after_destroy] }

      it 'should observe each supplied event' do
        events.each do |event|
          dependency.should_receive(:observe).with(event).ordered
        end
        subject
      end
    end

    context 'when no events are supplied' do
      it 'should observe each of the default events' do
        Dependency::DEFAULT_EVENTS.each do |event|
          dependency.should_receive(:observe).with(event).ordered
        end
        subject
      end
    end
  end

  describe "#observe" do
    subject { dependency.observe(event) }

    let(:event) { :after_create }

    before do
      model_class.stub(event)
    end

    it "should register itself for callbacks" do
      model_class.should_receive(event).with(dependency)
      subject
    end
  end
end