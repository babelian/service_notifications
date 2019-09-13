require 'spec_helper'

module ServiceNotifications
  describe Renderer do
    let(:renderer) do
      described_class.new(template: template)
    end

    let(:objects) do
      {}
    end

    let(:rendered) do
      renderer.call(objects)
    end

    describe '#call' do
      let(:template) do
        Fabricate(:template)
      end

      let(:objects) do
        template.config.data[:objects]
      end

      it 'renders and interpolates' do
        expect(rendered).to include objects.values.first
      end

      it 'raises errors' do
        expect do
          described_class.new(template: '{{').call({})
        end.to raise_error(Liquid::SyntaxError)
      end
    end

    describe '#money filter' do
      let(:objects) do
        {
          money_options: {
            default: { no_cents_if_whole: false },
            no_cents: { no_cents_if_whole: true }
          }
        }
      end

      let(:template) { '' }

      {
        "{{ '100USD' | money }}" => '$1.00',
        "{{ '100USD' | money: 'no_cents' }}" => '$1',
        "{{ '100USD' | money: 'unknown' }}" => '$1.00'
      }.each do |input, output|
        it "#{input} => #{output}" do
          template.replace(input)
          expect(rendered).to eq(output)
        end
      end

      it 'raises errors when necessary' do
        template.replace("{{ 'abc' | money }}")
        expect { rendered }.to raise_error(/invalid input/)
      end
    end
  end
end