require 'spec_helper'

describe Ship do
  it { should have_many(:deployments) }
  it { should have_many(:games) }
end
