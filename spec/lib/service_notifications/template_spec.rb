require 'spec_helper'

module ServiceNotifications
  describe Template, type: :model do
    # template maybe a reserved word in Rspec, odd results when using it exclusively.
    subject { template }

    let(:template) { Fabricate(:template) }

    it '.creates' do
      expect(template).to be_persisted
    end

    it 'persists config' do
      config = subject.config
      template = Template.find(subject.id)
      expect(template.config).to eq(config)
    end
  end
end