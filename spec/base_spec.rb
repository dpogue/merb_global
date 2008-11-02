require 'spec_helper'

class TestBase
  include Merb::Global
end

describe Merb::Global do
  describe '.message_provider' do
    it 'should return the default provider' do
      provider = mock 'provider'
      Merb::Global::MessageProviders.expects(:provider).returns(provider)
      TestBase.new.message_provider.should == provider
    end
  end
  
  describe '.date_provider' do
    it 'should return the default provider' do
      provider = mock 'provider'
      Merb::Global::DateProviders.expects(:provider).returns(provider)
      TestBase.new.date_provider.should == provider
    end
  end
  
  describe '.numeric_provider' do
    it 'should return the default provider' do
      provider = mock 'provider'
      Merb::Global::NumericProviders.expects(:provider).returns(provider)
      TestBase.new.numeric_provider.should == provider
    end
  end
  

  describe '._' do
    before do
      Merb::Global::Locale.current = Merb::Global::Locale.new('en')
    end
    
    describe 'message' do
      it 'should send singular and nil if plural not given' do
        test_base = TestBase.new
        test_base.message_provider = mock do |provider|
          expected_args = ['a', nil, {:n => 1, :lang => 'en'}]
          provider.expects(:localize).with(*expected_args).returns('b')
        end
        test_base._('a').should == 'b'
      end
      
      it 'should send singular and plural if both given' do
        test_base = TestBase.new
        test_base.message_provider = mock do |provider|
          expected_args = ['a', 'b', {:n => 1, :lang => 'en'}]
          provider.expects(:localize).with(*expected_args).returns('a')
        end
        test_base._('a', 'b').should == 'a'
      end
      
      it 'should send the proper number if given' do
        test_base = TestBase.new
        test_base.message_provider = mock do |provider|
          expected_args = ['a', 'b', {:n => 2, :lang => 'en'}]
          provider.expects(:localize).with(*expected_args).returns('b')
        end
        test_base._('a', 'b', :n => 2).should == 'b'
      end
      
      it 'should raise ArgumentException for wrong number of arguments' do
        lambda {TestBase.new._ 'a', 'b', 'c'}.should raise_error(ArgumentError)
      end
    end
    
    describe 'with date' do
      it 'should send the date and format' do
        test_base = TestBase.new
        time = Time.new
        result = mock
        test_base.date_provider = mock do |provider|
          expected_args = [Merb::Global::Locale.new('en'), time, '%A']
          provider.expects(:localize).with(*expected_args).returns(result)
        end
        test_base._(time, '%A').should == result
      end

      it 'should send the date, format and language if given' do
        test_base = TestBase.new
        time = Time.new
        result = mock
        test_base.date_provider = mock do |provider|
          expected_args = [Merb::Global::Locale.new('fr'), time, '%A']
          provider.expects(:localize).with(*expected_args).returns(result)
        end
        test_base._(time, '%A', :lang => Merb::Global::Locale.new('fr')).should == result
      end
      
      it 'should raise an error on wrong arguments' do
        time = Time.new
        lambda {TestBase.new._(time)}.should raise_error(ArgumentError)
        lambda {TestBase.new._(time, '', 1)}.should raise_error(ArgumentError)
      end
    end
    
    describe 'with number' do
      it 'should send the number' do
        test_base = TestBase.new
        test_base.numeric_provider = mock do |provider|
          expected_args = [Merb::Global::Locale.new('en'), 1.0]
          provider.expects(:localize).with(*expected_args).returns('1,0')
        end
        test_base._(1.0).should == '1,0'
      end
      
      it 'should send the number and language if given' do
        test_base = TestBase.new
        test_base.numeric_provider = mock do |provider|
          expected_args = [Merb::Global::Locale.new('pl'), 1.0]
          provider.expects(:localize).with(*expected_args).returns('1,0')
        end
        test_base._(1.0, :lang => Merb::Global::Locale.new('pl')).should == '1,0'
      end

      it 'should raise an error on wrong arguments' do
        lambda {TestBase.new._(1.0, 1)}.should raise_error(ArgumentError)
      end
    end
    it 'should raise an error on no argument' do
      lambda {TestBase.new._}.should raise_error(ArgumentError)
    end
  end
end
