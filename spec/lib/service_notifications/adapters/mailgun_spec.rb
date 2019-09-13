require 'spec_helper'

module ServiceNotifications
  describe Adapters::Mailgun do
    let(:kind) { 'mail' }

    let(:content) do
      Content.load('mail', post: post)
    end

    let(:options) do
      { content: content }
    end

    let(:mailgun) do
      described_class.new(options)
    end

    before do
      ENV['MAILGUN_API_KEY'] ||= 'test'
      ENV['MAILGUN_DOMAIN'] ||= 'mg.test.org'
    end

    it '.new' do
      expect(mailgun).to be_a(described_class)
    end

    #
    # Options
    #

    describe '#api_key' do
      it 'from ENV' do
        expect(ENV['MAILGUN_API_KEY']).to be_present
        expect(mailgun.api_key).to eq(ENV['MAILGUN_API_KEY'])
      end
      it 'from option' do
        options[:api_key] = '123'
        expect(mailgun.api_key).to eq('123')
      end
    end

    describe '#domain' do
      it 'passed in as options' do
        options[:domain] = 'domain.com'
        expect(mailgun.domain).to eq('domain.com')
      end

      it 'from ENV' do
        expect(ENV['MAILGUN_DOMAIN']).to be_present
        expect(mailgun.domain).to eq(ENV['MAILGUN_DOMAIN'])
      end

      # it 'defaults to domain in content.from if not passed' do
      #   mailgun.instance_variable_set('@domain', nil)
      #   expect(post.content.from).to include(mailgun.domain)
      # end
    end

    describe '#method_missing' do
      it 'delegates to #content' do
        expect(mailgun.to).to eq(content.to)
      end

      it 'or calls super and raises' do
        expect { mailgun.missing }.to raise_error(NoMethodError)
      end
    end

    #
    # Action
    #

    describe '#call' do
      let(:options) do
        {
          api_key: '123',
          domain: 'domain.com',
          content: content
        }
      end

      it '#call' do
        url = 'https://api:123@api.mailgun.net/v3/domain.com/messages'
        allow(RestClient).to receive(:post).with(url, mailgun.payload).and_return(
          OpenStruct.new(code: 200, body: { ok: 1 }.to_json)
        )

        expect(mailgun.call).to eq(ok: 1)
        expect(RestClient).to have_received(:post)
      end
    end

    it '#payload' do
      expect(mailgun.payload).to eq(
        from: post.channel.from, to: post.data[:email],
        subject: post.content.subject,
        text: post.content.plain,
        html: post.content.html
      )
    end
  end
end