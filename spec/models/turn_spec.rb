require 'spec_helper'

describe Turn do
  it { should belong_to(:game) }
  it { should validate_presence_of :position }

end
