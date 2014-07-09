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

  describe 'instructions.js.hbs.hamlbars' do
    Idobata::Hook.all.each do |hook|
      describe hook do
        subject { hook }

        let(:path) { hook.hook_root.join('instructions.js.hbs.hamlbars').to_s }

        it 'should be compiled successfully' do
          Tilt.new(path).render
        end
      end
    end
  end
end
