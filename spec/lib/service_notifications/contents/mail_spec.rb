  require 'spec_helper'

module ServiceNotifications
  describe Contents::Mail do
    let(:kind) { 'mail' }

    let(:options) do
      { post: post }
    end

    let(:html) do
      html = <<~HTML
        <html>
          <title>HTML Subject </title>
          <head>
            <style>
              body { padding: 24px; }
            </style>
          <body>
            Blah
          </body>
        </html>
      HTML

      html.strip
    end

    let(:plain) do
      <<~STR
        Subject: Plain Subject

        Body

        Subject: in body
      STR
    end

    let(:content) do
      described_class.new(options)
    end

    before do
      allow(content).to receive(:template_for).with('html').and_return html
      allow(content).to receive(:template_for).with('plain').and_return plain
    end

    it '.new with options' do
      expect(content).to be_a(described_class)
    end

    #
    # Instance Methods
    #

    describe '#plain' do
      it 'strips subject' do
        expect(content.plain).to eq plain.split("\n")[1..-1].join("\n").strip
      end
    end

    describe '#html' do
      it 'works' do
        expect(content.html).to eq html
      end
    end

    describe '#premailer' do
      before do
        plain.replace(' ')
      end

      it 'without premailer in body tag' do
        expect(content.html).to include('<body>')
      end

      it 'with premailer in body tag' do
        html.sub!('<html', '<html premailer')
        expect(content.html).to include('<html>')
        expect(content.html).to include('<body style="padding: 24px;"')
        expect(content.plain).to include('Blah')
      end
    end

    it '#from' do
      expect(content.from).to eq post.channel.from
    end

    describe '#subject' do
      it 'none' do
        html.replace(' ')
        plain.replace(' ')
        expect(content.subject).to eq 'no subject'
      end

      it 'from post.data[:subject]' do
        post.data[:subject] = 'post data subject'
        expect(content.subject).to eq('post data subject')
      end

      it 'from post.objects[:subject]' do
        post.data[:objects] = { subject: 'post object subject' }
        expect(content.subject).to eq('post object subject')
      end

      it 'from html' do
        expect(content.subject).to eq 'HTML Subject'
      end

      it 'from plain' do
        html.replace(' ')
        expect(content.subject).to eq 'Plain Subject'
      end
    end
  end
end