require 'spec_helper'

describe P45 do
  let(:api) {P45.new(:email=>'test@test.com', :name=>'test')}

  context "#register" do
    before(:each) do
      VCR.use_cassette 'p45/register' do
        api.register
      end
    end

    it "should register and return an id" do
      api.id.should_not be_nil
    end

    it "should set the counter nuke coordinates" do
      api.counter_nuke.keys.should == [:x, :y]
    end
  end


  context 'when not registered' do
    context "#nuke" do
      it "should return nil if an id is not provided yet" do
        api.nuke({:x=>0, :y=>0}).should == nil
      end
    end

    context "#status" do
      it "should return nil" do
        api.status.should be_nil
      end
    end

    context "#prize" do
      it "should return nil" do
        api.prize.should == nil
      end
    end
  end


  context 'when registered' do
    before(:each) do
      VCR.use_cassette 'p45/register' do
        api.register
      end
    end

    context "#nuke" do
      it "should send attack position and return self" do
        VCR.use_cassette 'p45/nuke' do
          api.nuke({:x=>0, :y=>0}).should == api
        end
      end
    end

    context "#counter_nuke" do
      it "should return the coordinates of p45 counter attack" do
        VCR.use_cassette 'p45/nuke' do
          api.nuke({:x=>0, :y=>0})
        end

        api.counter_nuke[:x].should_not be_nil
      end
    end

    context "#status" do
      it "should return the status of the action (hit/miss/over)" do
        VCR.use_cassette 'p45/nuke' do
          api.nuke({:x=>0, :y=>0})
        end
      end

      it "should be nil when first registered" do
        api.status.should be_nil
      end

      it "it should return lost when game over" do
        VCR.use_cassette 'p45/last_nuke' do
          api.nuke({:x=>0, :y=>0})
        end
        api.status.should eql('lost')
      end

      it "it should return lost when game over" do
        VCR.use_cassette 'p45/last_nuke' do
          api.nuke({:x=>0, :y=>0})
        end
        api.status.should eql('lost')
      end
    end

  end
end