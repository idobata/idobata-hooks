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

        describe 'style.sass' do
          it 'should be compiled successfully' do
            path = hook.hook_root.join('style.sass')

            next unless path.exist?

            expect {
              Tilt.new(path.to_s).render
            }.to_not raise_error
          end
        end

        describe 'help.html.haml' do
          it 'should be compiled successfully' do
            path = hook.hook_root.join('help.html.haml')

            expect {
              Haml::Engine.new(path.read).render
            }.to_not raise_error
          end
        end
      end
    end
  end
end
