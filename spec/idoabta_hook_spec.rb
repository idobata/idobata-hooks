require 'spec_helper'

describe Idobata::Hook do
  describe 'configuration' do
    Idobata::Hook.all.each do |hook|
      describe hook do
        subject { hook }

        its(:screen_name) { should be_present }
        its(:icon_url)    { should be_present }
      end
    end

    describe 'identifier' do
      it 'should be uniq' do
        expect(Idobata::Hook.all.map(&:identifier).uniq.count).to eq(Idobata::Hook.all.count)
      end
    end
  end

  describe 'assets compiling' do
    Idobata::Hook.all.each do |hook|
      describe hook do
        subject { hook }

        let(:paths) { Dir.glob(hook.hook_root.join('**/*.{hamlbars,sass}')) }

        it 'should be compiled successfully' do
          paths.each do |path|
            expect { Tilt.new(path).render }.to_not raise_error
          end
        end
      end
    end
  end
end
