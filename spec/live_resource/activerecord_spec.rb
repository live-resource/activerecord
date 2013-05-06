require 'spec_helper'

describe LiveResource::ActiveRecord do
  it 'should have a version number' do
    LiveResource::ActiveRecord::VERSION.should_not be_nil
  end
end
