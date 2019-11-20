# frozen_string_literal: true

module ServiceNotifications
  module Contents
    # Mail Content
    class Mail < Content
      PLAIN_SUBJECT_REGEXP = /^Subject: (.*)/.freeze

      # @return [String]
      def from
        post.data[:from] || post.objects[:from] || channel.from
      end

      # @return [String]
      def reply_to
        post.data[:reply_to] || post.objects[:reply_to] || channel.reply_to
      end

      # @return [String]
      def to
        post.data[:email]
      end

      # @return [String] pulls from data, <title> tag, or first line "Subject: ..."
      def subject
        subject = post.data[:subject] || post.objects[:subject]
        subject ||= html.to_s[%r{<title>(.*)</title>}, 1] || rendered.plain[/^Subject: (.*)/, 1]
        subject.try(:strip) || 'no subject'
      end

      # @return [String]
      def html
        return @html if instance_variable_defined?('@html')

        @html = premailer.html || rendered.html
        @html = nil if @html.empty?
        @html
      end

      # @return [String]
      def plain
        return @plain if instance_variable_defined?('@plain')

        @plain = rendered.plain.sub(PLAIN_SUBJECT_REGEXP, '').strip
        @plain = premailer.plain if @plain.empty?
        @plain = nil if @plain.empty?
        @plain
      end

      private

      def rendered
        @rendered = OpenStruct.new(
          html: render('html').to_s.strip,
          plain: render('plain').to_s
        )
      end

      # Premailer

      def html_file
        @html_file ||= begin
          html = rendered.html
                         .sub('<html premailer=""', '<html')
                         .sub("<html premailer=''", '<html')
                         .sub('<html premailer', '<html')
                         .force_encoding('utf-8')

          file = Tempfile.new
          file.write html
          file.rewind
          file
        end
      end

      # use premailer if <body premailer
      def premailer
        return @premailer if instance_variable_defined?('@premailer')
        return @premailer = OpenStruct.new unless rendered.html =~ /<html premailer/

        @premailer ||= begin
          require 'nokogiri'
          premailer = premailer_class.new(html_file.path)
          # plain must be rendered first due to Premailer bug
          OpenStruct.new(plain: premailer.to_plain_text, html: premailer.to_inline_css)
        end
      end

      def premailer_class
        require 'premailer'
        Premailer::Adapter.use = :nokogiri_fast
        Premailer
      end
    end
  end
end